Class {
	#name : #SYMLGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'expression',
		'optionalExpression',
		'semicolon',
		'expressionList',
		'identifier',
		'keywordEnd',
		'blockExpression',
		'lcbracket',
		'rcbracket',
		'dot',
		'assignmentExpression',
		'chainExpression',
		'assignOperator',
		'chainReceiver',
		'chainKeywordMessage',
		'chainedMessage',
		'binaryExpression',
		'keyword',
		'chainUnaryMessage',
		'unaryExpression',
		'primaryExpression',
		'unaryExpressionSuffix',
		'unaryExpressionSuffixMessage',
		'unaryExpressionSuffixCall',
		'anyIdentifier',
		'lparent',
		'callExpressionArguments',
		'rparent',
		'comma',
		'parentExpression',
		'identifierExpression',
		'anyChainExpression',
		'implicitContextChainExpression',
		'floatNumber',
		'integerNumber',
		'number',
		'literals',
		'commaExpression',
		'pragmaChainKeywordMessage',
		'pragmaChainedMessage',
		'pragma',
		'symbolKeywordLiteral',
		'symbolOperatorLiteral',
		'symbolIdentifierLiteral',
		'symbolStringLiteral',
		'symbolLiteral',
		'pragmaChainUnaryMessage',
		'anyBinaryOperator',
		'genericBinaryOperator',
		'stringLiteral',
		'characterLiteral',
		'litLParent',
		'literalArrayLiteral',
		'literalArrayIdentifier',
		'literalArrayBinaryOperator',
		'innerLiteralArrayLiteral',
		'literalArray',
		'languageScapeExpression',
		'languageScapeOperator',
		'lbracket',
		'rbracket',
		'literalArrayKeyword',
		'lowPrecedenceBinaryOperator',
		'lowPrecedenceExpression',
		'unarySuffixSubscript',
		'quoteExpressions',
		'quoteExpression',
		'quasiquoteExpression',
		'quote',
		'quasiquote',
		'unquoteExpression',
		'spliceExpression',
		'quasiunquote',
		'splice',
		'lessThan',
		'greaterThan'
	],
	#classVars : [
		'SpecialOperators'
	],
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #initialization }
SYMLGrammar class >> initialize [
	"
	self initialize
	"
	super initialize.
	
	SpecialOperators := Set newFrom: #(
		!
		~

		*
		/
		%
		+
		-
		<<
		>>
		<=
		>=
		<
		>
		=
		~=
		==
		~~
		&
		^
		|
		&&
		#,
	)
]

{ #category : #tokens }
SYMLGrammar >> anyBinaryOperator [
	^ self operator: (PP2PredicateObjectNode anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #accessing }
SYMLGrammar >> anyChainExpression [
	^ implicitContextChainExpression / chainExpression
]

{ #category : #accessing }
SYMLGrammar >> anyIdentifier [
	^ (self token: self identifierStart , self identifierInner star , $: asPParser not)
]

{ #category : #tokens }
SYMLGrammar >> assignOperator [
	^ self operator: ':=' asPParser
]

{ #category : #accessing }
SYMLGrammar >> assignmentExpression [
	^ lowPrecedenceExpression , (assignOperator , assignmentExpression) optional
]

{ #category : #accessing }
SYMLGrammar >> binaryExpression [
	| binExpr binOpDo prefixOpDo postfixOpDo |
	binExpr := SYMLExpressionParserBuilder new.
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
	^ binExpr finish
]

{ #category : #accessing }
SYMLGrammar >> blockExpression [
	^ lcbracket , pragma star, expressionList , rcbracket
]

{ #category : #accessing }
SYMLGrammar >> callExpressionArguments [
	^ commaExpression optional
]

{ #category : #accessing }
SYMLGrammar >> chainExpression [
	^ chainReceiver , chainKeywordMessage optional , (semicolon , chainedMessage) star
]

{ #category : #accessing }
SYMLGrammar >> chainKeywordMessage [
	^ (keyword , binaryExpression) plus
]

{ #category : #accessing }
SYMLGrammar >> chainReceiver [
	^ binaryExpression
]

{ #category : #accessing }
SYMLGrammar >> chainUnaryMessage [
	^ anyIdentifier
]

{ #category : #accessing }
SYMLGrammar >> chainedMessage [
	^ chainKeywordMessage / chainUnaryMessage
]

{ #category : #accessing }
SYMLGrammar >> characterLiteral [
	^ self token: $' asPParser , ($' asPParser negate / ($\ asPParser , #any asPParser)) star , $' asPParser
]

{ #category : #accessing }
SYMLGrammar >> colon [
	^ self token: $: asPParser
]

{ #category : #tokens }
SYMLGrammar >> comma [
	^ self token: $, asPParser
]

{ #category : #accessing }
SYMLGrammar >> commaExpression [
	^ assignmentExpression , (comma, assignmentExpression) star, comma optional
]

{ #category : #tokens }
SYMLGrammar >> decimalIntegerNumber [
	^ self token: self numberSign optional, #digit asPParser plus
]

{ #category : #tokens }
SYMLGrammar >> dot [
	^ self token: $. asPParser
]

{ #category : #accessing }
SYMLGrammar >> expression [
	^ commaExpression
]

{ #category : #accessing }
SYMLGrammar >> expressionList [
	^ optionalExpression, (dot , optionalExpression) star
]

{ #category : #tokens }
SYMLGrammar >> floatNumber [
	^ self token: self numberSign optional, #digit asPParser plus, $. asPParser , #digit asPParser plus , (self numberEMark , self numberSign optional, #digit asPParser plus) optional
]

{ #category : #tokens }
SYMLGrammar >> genericBinaryOperator [
	^ anyBinaryOperator >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetit2Failure not and: [ SpecialOperators includes: result inputValue ]) ifTrue: [
			stream restore: memento.
			PP2Failure message: 'expected a generic operator, not an special.' context: stream
		] ifFalse: [
			result
		]
	]
]

{ #category : #tokens }
SYMLGrammar >> greaterThan [
	^ self token: $> asPParser
]

{ #category : #tokens }
SYMLGrammar >> identifier [
	^ self token: self identifierStart , self identifierInner star , $: asPParser not
]

{ #category : #accessing }
SYMLGrammar >> identifierExpression [
	^ identifier
]

{ #category : #tokens }
SYMLGrammar >> identifierInner [
	^ #letter asPParser / #digit asPParser / $_ asPParser
]

{ #category : #tokens }
SYMLGrammar >> identifierStart [
	^ #letter asPParser / $_ asPParser
]

{ #category : #accessing }
SYMLGrammar >> implicitContextChainExpression [
	^ chainKeywordMessage , (semicolon , chainedMessage) star
]

{ #category : #accessing }
SYMLGrammar >> innerLiteralArrayLiteral [
	^ lparent , literalArrayLiteral star , rparent
]

{ #category : #tokens }
SYMLGrammar >> integerNumber [
	^ self token: self numberSign optional, #digit asPParser plus , ($r asPParser , (#letter asPParser / #digit asPParser) plus) optional
]

{ #category : #tokens }
SYMLGrammar >> keyword [
	^ self token: self identifierStart , self identifierInner star , $: asPParser
]

{ #category : #tokens }
SYMLGrammar >> keywordEnd [
	^ (self identifierStart / #digit asPParser ) not
]

{ #category : #accessing }
SYMLGrammar >> languageScapeExpression [
	^ languageScapeOperator , identifier , (self token: self scapedLanguageContent)
]

{ #category : #tokens }
SYMLGrammar >> languageScapeOperator [
	^ self token: '$$' asPParser
]

{ #category : #tokens }
SYMLGrammar >> lbracket [
	^ self token: $[ asPParser
]

{ #category : #tokens }
SYMLGrammar >> lcbracket [
	^ self token: ${ asPParser
]

{ #category : #tokens }
SYMLGrammar >> lessThan [
	^ self token: $< asPParser
]

{ #category : #tokens }
SYMLGrammar >> litLParent [
	^ self token: '#(' asPParser
]

{ #category : #accessing }
SYMLGrammar >> literalArray [
	^ litLParent , literalArrayLiteral star , rparent
]

{ #category : #accessing }
SYMLGrammar >> literalArrayBinaryOperator [
	^ anyBinaryOperator
]

{ #category : #accessing }
SYMLGrammar >> literalArrayIdentifier [
	^ identifier
]

{ #category : #accessing }
SYMLGrammar >> literalArrayKeyword [
	^ self token: (self identifierStart , self identifierInner star , $: asPParser) plus
]

{ #category : #accessing }
SYMLGrammar >> literalArrayLiteral [
	^ literalArrayKeyword / literalArrayIdentifier / literalArrayBinaryOperator / innerLiteralArrayLiteral / literals
]

{ #category : #accessing }
SYMLGrammar >> literals [
	^ number / stringLiteral / characterLiteral / literalArray / symbolLiteral
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> lowPrecedenceBinaryOperator [
	^ self operator: '::' asPParser , (PP2PredicateObjectNode anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> lowPrecedenceExpression [
	^ anyChainExpression , (lowPrecedenceBinaryOperator , anyChainExpression) star
]

{ #category : #tokens }
SYMLGrammar >> lparent [
	^ self token: $( asPParser
]

{ #category : #white }
SYMLGrammar >> multiLineComment [
	^ '/*' asPParser ,
		( ($* asPParser negate) /
			($* asPParser , $/ asPParser negate)
		) star ,
	'*/' asPParser
]

{ #category : #white }
SYMLGrammar >> newline [
	^ String crlf asPParser / String cr asPParser / String lf asPParser
]

{ #category : #accessing }
SYMLGrammar >> number [
	^ floatNumber / integerNumber
]

{ #category : #tokens }
SYMLGrammar >> numberEMark [
	^ $e asPParser / $E asPParser
]

{ #category : #tokens }
SYMLGrammar >> numberSign [
	^ $+ asPParser / $- asPParser
]

{ #category : #operators }
SYMLGrammar >> operate: left with: right do: operation [
	^ { operation . left . right }
]

{ #category : #tokens }
SYMLGrammar >> operator: aParser [
	^ self token: aParser
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> operatorString: aString [
	^ anyBinaryOperator >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetit2Failure not and: [ result value ~= aString]) ifTrue: [
			stream restore: memento.
			PP2Failure message: 'expected a special operator' context: stream
		] ifFalse: [
			result
		]
	]
]

{ #category : #accessing }
SYMLGrammar >> optionalExpression [
	^ expression optional
]

{ #category : #accessing }
SYMLGrammar >> parentExpression [
	^ lparent , expression , rparent
]

{ #category : #operators }
SYMLGrammar >> postfix: operation operate: operand [
	^ { operation . operand }
]

{ #category : #accessing }
SYMLGrammar >> pragma [
	^ lessThan , pragmaChainedMessage , greaterThan
	
]

{ #category : #accessing }
SYMLGrammar >> pragmaChainKeywordMessage [
	^ (keyword , primaryExpression) plus
]

{ #category : #accessing }
SYMLGrammar >> pragmaChainUnaryMessage [
	^ anyIdentifier
]

{ #category : #accessing }
SYMLGrammar >> pragmaChainedMessage [
	^ pragmaChainKeywordMessage / pragmaChainUnaryMessage
]

{ #category : #operators }
SYMLGrammar >> prefix: operation operate: operand [
	^ { operation . operand }
]

{ #category : #accessing }
SYMLGrammar >> primaryExpression [
	^ quoteExpressions / languageScapeExpression / parentExpression / identifierExpression / blockExpression / literals
]

{ #category : #tokens }
SYMLGrammar >> quasiquote [
	^ self token: '``' asPParser
]

{ #category : #'macro operators' }
SYMLGrammar >> quasiquoteExpression [
	^ quasiquote , primaryExpression 
]

{ #category : #tokens }
SYMLGrammar >> quasiunquote [
	^ self token: '`,' asPParser
]

{ #category : #tokens }
SYMLGrammar >> quote [
	^ self token: '`''' asPParser
]

{ #category : #'macro operators' }
SYMLGrammar >> quoteExpression [
	^ quote , primaryExpression 
]

{ #category : #'macro operators' }
SYMLGrammar >> quoteExpressions [
	^ quoteExpression / quasiquoteExpression / unquoteExpression / spliceExpression
]

{ #category : #tokens }
SYMLGrammar >> rbracket [
	^ self token: $] asPParser
]

{ #category : #tokens }
SYMLGrammar >> rcbracket [
	^ self token: $} asPParser
]

{ #category : #tokens }
SYMLGrammar >> rparent [
	^ self token: $) asPParser
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> scapeLanguageContentOpen: openCharacter close: closeCharacter [
	^ SYMLScapedLanguagePP2Node new openCharacter: openCharacter; closeCharacter: closeCharacter; yourself
]

{ #category : #accessing }
SYMLGrammar >> scapedLanguageContent [
	^ (self scapeLanguageContentOpen: $[ close: $]) /
		(self scapeLanguageContentOpen: $( close: $)) /
		(self scapeLanguageContentOpen: ${ close: $})
]

{ #category : #accessing }
SYMLGrammar >> semicolon [
	^ self token: $; asPParser
]

{ #category : #white }
SYMLGrammar >> singleLineComment [
	^ '//' asPParser, self newline negate star, self newline
]

{ #category : #white }
SYMLGrammar >> spaces [
	^ #space asPParser plus
]

{ #category : #tokens }
SYMLGrammar >> splice [
	^ self token: '`@' asPParser
]

{ #category : #'macro operators' }
SYMLGrammar >> spliceExpression [
	^ splice , primaryExpression
]

{ #category : #accessing }
SYMLGrammar >> start [
	^ self whites, expressionList , self whites, #endOfInput asPParser
]

{ #category : #accessing }
SYMLGrammar >> stringLiteral [
	^ self token: $" asPParser , ($" asPParser negate / ($\ asPParser , #any asPParser)) star , $" asPParser
]

{ #category : #accessing }
SYMLGrammar >> symbolIdentifierLiteral [
	^ self token: $# asPParser , self identifierStart , self identifierInner star
]

{ #category : #accessing }
SYMLGrammar >> symbolKeywordLiteral [
	^ self token: $# asPParser, (self identifierStart , self identifierInner star , $: asPParser) plus
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> symbolLiteral [
	^ symbolKeywordLiteral / symbolOperatorLiteral / symbolIdentifierLiteral / symbolStringLiteral
]

{ #category : #accessing }
SYMLGrammar >> symbolOperatorLiteral [
	^ self token: $# asPParser , (PP2PredicateObjectNode anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #accessing }
SYMLGrammar >> symbolStringLiteral [
	^ self token: '#"' asPParser , ($" asPParser negate / ($\ asPParser , #any asPParser)) star , $" asPParser
]

{ #category : #tokens }
SYMLGrammar >> token: aParser [
	^ (aParser token: SYMLToken) trim: self whites
	"^ (self whites , (aParser token: SYMLTokenPP2)) ==> [ :parts |
			parts second
				previousComments: parts first;
				yourself
	]"
]

{ #category : #accessing }
SYMLGrammar >> unaryExpression [
	^ primaryExpression , unaryExpressionSuffix star
]

{ #category : #accessing }
SYMLGrammar >> unaryExpressionSuffix [
	^ unaryExpressionSuffixMessage / unaryExpressionSuffixCall / unarySuffixSubscript
]

{ #category : #accessing }
SYMLGrammar >> unaryExpressionSuffixCall [
	^ lparent , callExpressionArguments , rparent
]

{ #category : #accessing }
SYMLGrammar >> unaryExpressionSuffixMessage [
	^ anyIdentifier
]

{ #category : #accessing }
SYMLGrammar >> unarySuffixSubscript [
	^ lbracket , expression , rbracket
]

{ #category : #'macro operators' }
SYMLGrammar >> unquoteExpression [
	^ quasiunquote , primaryExpression
]

{ #category : #white }
SYMLGrammar >> white [
	^ self singleLineComment / self multiLineComment / self spaces
]

{ #category : #white }
SYMLGrammar >> whites [
	^ self white star
]
