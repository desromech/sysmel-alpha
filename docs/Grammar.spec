identifier
	^ self token: identifierStart ,  identifierInner star , $: asParser not

blockExpression
	^ lcbracket , pragma star, expressionList , rcbracket

expressionList
	^ optionalExpression, (dot , optionalExpression) star

spliceExpression
	^ splice , primaryExpression

characterLiteral
	^ self token: $' asParser , ($' asParser negate / ($\ asParser , #any asParser)) star , $' asParser

literalArrayBinaryOperator
	^ anyBinaryOperator

unarySuffixSubscript
	^ lbracket , expression , rbracket

quoteExpressions
	^ quoteExpression / quasiquoteExpression / unquoteExpression / spliceExpression

commaExpression
	^ assignmentExpression , (comma, assignmentExpression) star, comma optional

expression
	^ commaExpression

spaces
	^ #space asParser plus

comma
	^ self token: $, asParser

operatorString: aString
	^ anyBinaryOperator >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ result inputValue ~= aString]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected a special operator' context: stream
		] ifFalse: [
			result
		]
	]

languageScapeExpression
	^ languageScapeOperator , identifier , (self token: scapedLanguageContent)

postfix: operation operate: operand
	^ { operation . operand }

lbracket
	^ self token: $[ asParser

symbolStringLiteral
	^ self token: '#"' asParser , ($" asParser negate / ($\ asParser , #any asParser)) star , $" asParser

symbolIdentifierLiteral
	^ self token: $# asParser , identifierStart , identifierInner star

keyword: aKeyword
	^ (aKeyword asParser , keywordEnd) token trim: white

litLParent
	^ self token: '#(' asParser

quote
	^ self token: '`''' asParser

quasiquote
	^ self token: '``' asParser

quasiunquote
	^ self token: '`,' asParser

chainKeywordMessage
	^ (keyword , binaryExpression) plus

unaryExpression
	^ primaryExpression , unaryExpressionSuffix star

unquoteExpression
	^ quasiunquote , primaryExpression

literalArrayIdentifier
	^ identifier

keyword
	^ self token: identifierStart , identifierInner star , $: asParser

identifierStart
	^ #letter asParser / $_ asParser

prefix: operation operate: operand
	^ { operation . operand }

numberSign
	^ $+ asParser / $- asParser

scapedLanguageContent
	^ (self scapeLanguageContentOpen: $[ close: $]) /
		(self scapeLanguageContentOpen: $( close: $)) /
		(self scapeLanguageContentOpen: ${ close: $})

operate: left with: right do: operation
	^ { operation . left . right }

symbolKeywordLiteral
	^ self token: $# asParser, (identifierStart , identifierInner star , $: asParser) plus

assignmentExpression
	^ lowPrecedenceExpression , (assignOperator , assignmentExpression) optional

white
	^ singleLineComment / multiLineComment / spaces

chainUnaryMessage
	^ anyIdentifier

optionalExpression
	^ expression optional

unaryExpressionSuffixCall
	^ lparent , callExpressionArguments , rparent

callExpressionArguments
	^ commaExpression optional

rbracketbracket
	^ self token: ']]' asParser

lowPrecedenceBinaryOperator
	^ self operator: '::' asParser , (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus

dot
	^ self token: $. asParser

lparent
	^ self token: $( asParser

implicitContextChainExpression
	^ chainKeywordMessage , (semicolon , chainedMessage) star

rparent
	^ self token: $) asParser

pragma
	^ lbracketbracket , pragmaChainedMessage, rbracketbracket

lowPrecedenceExpression
	^ anyChainExpression , (lowPrecedenceBinaryOperator , anyChainExpression) star

rbracket
	^ self token: $] asParser

rcbracket
	^ self token: $} asParser

singleLineComment
	^ '//' asParser, newline negate star, newline

identStart
	^ #letter asParser / $_ asParser

pragmaChainUnaryMessage
	^ anyIdentifier

scapeLanguageContentOpen: openCharacter close: closeCharacter
	^ SYMLScapedLanguageParser new openCharacter: openCharacter; closeCharacter: closeCharacter; yourself

binaryExpression
	| binExpr binOpDo prefixOpDo postfixOpDo |
	binExpr := PPExpressionParser new.
	binExpr term: unaryExpression.
	binOpDo := [ :left :operation :right | self operate: left with: right do: operation. ].
	prefixOpDo := [ :operation :operand | self prefix: operation operate: operand ].
	postfixOpDo := [ :operand :operation | self postfix: operation operate: operand ].

	binExpr
		group: [ :g |
			"TODO: Is this a good idea?"
			g prefix: (self operatorString: '+') do: prefixOpDo.
			g prefix: (self operatorString: '-') do: prefixOpDo.
			g prefix: (self operatorString: '!') do: prefixOpDo.
			g prefix: (self operatorString: '~') do: prefixOpDo.
			];
		group: [ :g |
			g left: (self operatorString: '*') do: binOpDo.
			g left: (self operatorString: '/') do: binOpDo.
			g left: (self operatorString: '%') do: binOpDo.];
		group: [ :g |
			g left: (self operatorString: '+') do: binOpDo.
			g left: (self operatorString: '-') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '<<') do: binOpDo.
			g left: (self operatorString: '>>') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '<=') do: binOpDo.
			g left: (self operatorString: '>=') do: binOpDo.
			g left: (self operatorString: '<') do: binOpDo.
			g left: (self operatorString: '>') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '=') do: binOpDo.
			g left: (self operatorString: '==') do: binOpDo.
			g left: (self operatorString: '~=') do: binOpDo.
			g left: (self operatorString: '~~') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '&') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '^') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '|') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '&&') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '||') do: binOpDo. ];
		group: [ :g |
			g left: (genericBinaryOperator) do: binOpDo. ].
	^ binExpr

semicolon
	^ self token: $; asParser

chainExpression
	^ chainReceiver , chainKeywordMessage optional , (semicolon , chainedMessage) star

newline
	^ String crlf asParser / String cr asParser / String lf asParser

innerLiteralArrayLiteral
	^ lparent , literalArrayLiteral star , rparent

lcbracket
	^ self token: ${ asParser

literalArray
	^ litLParent , literalArrayLiteral star , rparent

pragmaChainedMessage
	^ pragmaChainKeywordMessage / pragmaChainUnaryMessage

genericBinaryOperator
	^ anyBinaryOperator >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ SpecialOperators includes: result inputValue ]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected a generic operator, not an special.' context: stream
		] ifFalse: [
			result
		]
	]

whites
	^ white star

symbolOperatorLiteral
	^ self token: $# asParser , (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus

integerNumber
	^ self token: numberSign optional, #digit asParser plus , ($r asParser , (#letter asParser | #digit asParser) plus) optional

lbracketbracket
	^ self token: '[[' asParser

anyBinaryOperator
	^ self operator: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus

splice
	^ self token: '`@' asParser

identifierInner
	^ #letter asParser / #digit asParser / $_ asParser

primaryExpression
	^ quoteExpressions / languageScapeExpression / parentExpression / identifierExpression / blockExpression / literals

identifierExpression
	^ identifier

pragmaChainKeywordMessage
	^ (keyword , primaryExpression) plus

chainedMessage
	^ chainKeywordMessage / chainUnaryMessage

decimalIntegerNumber
	^ self token: numberSign optional, #digit asParser plus

numberEMark
	^ $e asParser / $E asParser

unaryExpressionSuffixMessage
	^ anyIdentifier

token: aParser
	^ (whites , aParser token) ==> [ :parts | parts second ]

quasiquoteExpression
	^ quasiquote , primaryExpression

stringLiteral
	^ self token: $" asParser , ($" asParser negate / ($\ asParser , #any asParser)) star , $" asParser

colon
	^ self token: $: asParser

parentExpression
	^ lparent , expression , rparent

literals
	^ number / stringLiteral / characterLiteral / literalArray / symbolLiteral

assignOperator
	^ self operator: ':=' asParser

operator: aParser
	^ self token: aParser

keywordEnd
	^ (identStart / #digit asParser ) not

quoteExpression
	^ quote , primaryExpression

chainReceiver
	^ binaryExpression

literalArrayLiteral
	^ literalArrayKeyword / literalArrayIdentifier / literalArrayBinaryOperator / innerLiteralArrayLiteral / literals

anyIdentifier
	^ (self token: identifierStart ,  identifierInner star , $: asParser not)

literalArrayKeyword
	^ self token: (identifierStart , identifierInner star , $: asParser) plus

floatNumber
	^ self token: numberSign optional, #digit asParser plus, $. asParser , #digit asParser plus , (numberEMark , numberSign optional, #digit asParser plus) optional

unaryExpressionSuffix
	^ unaryExpressionSuffixMessage / unaryExpressionSuffixCall / unarySuffixSubscript

number
	^ floatNumber / integerNumber

languageScapeOperator
	^ self token: '$$' asParser

start
	^ whites, expressionList , whites, #eof asParser

multiLineComment
	^ '/*' asParser ,
		( ($* asParser negate) /
			($* asParser , $/ asParser negate)
		) star ,
	'*/' asParser

anyChainExpression
	^ implicitContextChainExpression / chainExpression

symbolLiteral
	^ symbolKeywordLiteral / symbolOperatorLiteral / symbolIdentifierLiteral / symbolStringLiteral
