Class {
	#name : #SysmelGrammar,
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
		'greaterThan',
		'blockClosureArguments',
		'verticalBar',
		'unaryExpressionSuffixUnquote',
		'dictionaryExpression',
		'sharp',
		'dictionaryElementList',
		'dictionaryElement',
		'dictionaryKey',
		'optionalDictionaryElement',
		'dictionaryExpressionKey',
		'colon',
		'dictionaryKeywordKey'
	],
	#classVars : [
		'SpecialOperators'
	],
	#category : #'SysmelLanguage-Sysmel-Parser'
}

{ #category : #initialization }
SysmelGrammar class >> initialize [
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
SysmelGrammar >> anyBinaryOperator [
	^ self operator: (PP2PredicateObjectNode anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #accessing }
SysmelGrammar >> anyChainExpression [
	^ implicitContextChainExpression / chainExpression
]

{ #category : #accessing }
SysmelGrammar >> anyIdentifier [
	^ (self token: self identifierStart , self identifierInner star , $: asPParser not)
]

{ #category : #tokens }
SysmelGrammar >> assignOperator [
	^ self operator: ':=' asPParser
]

{ #category : #accessing }
SysmelGrammar >> assignmentExpression [
	^ lowPrecedenceExpression , (assignOperator , assignmentExpression) optional
]

{ #category : #accessing }
SysmelGrammar >> binaryExpression [
	| binExpr binOpDo prefixOpDo postfixOpDo |
	binExpr := SysmelExpressionParserBuilder new.
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
SysmelGrammar >> blockClosureArguments [
	^ verticalBar , expression optional, verticalBar
]

{ #category : #accessing }
SysmelGrammar >> blockExpression [
	^ lcbracket , blockClosureArguments optional , pragma star, expressionList , rcbracket
]

{ #category : #accessing }
SysmelGrammar >> callExpressionArguments [
	^ commaExpression optional
]

{ #category : #accessing }
SysmelGrammar >> chainExpression [
	^ chainReceiver , chainKeywordMessage optional , (semicolon , chainedMessage) star
]

{ #category : #accessing }
SysmelGrammar >> chainKeywordMessage [
	^ (keyword , binaryExpression) plus
]

{ #category : #accessing }
SysmelGrammar >> chainReceiver [
	^ binaryExpression
]

{ #category : #accessing }
SysmelGrammar >> chainUnaryMessage [
	^ anyIdentifier
]

{ #category : #accessing }
SysmelGrammar >> chainedMessage [
	^ chainKeywordMessage / chainUnaryMessage
]

{ #category : #accessing }
SysmelGrammar >> characterLiteral [
	^ self token: $' asPParser , ($' asPParser negate / ($\ asPParser , #any asPParser)) star , $' asPParser
]

{ #category : #accessing }
SysmelGrammar >> colon [
	^ self token: $: asPParser
]

{ #category : #tokens }
SysmelGrammar >> comma [
	^ self token: $, asPParser
]

{ #category : #accessing }
SysmelGrammar >> commaExpression [
	^ assignmentExpression , (comma, assignmentExpression) star, comma optional
]

{ #category : #tokens }
SysmelGrammar >> decimalIntegerNumber [
	^ self token: self numberSign optional, #digit asPParser plus
]

{ #category : #accessing }
SysmelGrammar >> dictionaryElement [
	^ dictionaryKey , expression
]

{ #category : #accessing }
SysmelGrammar >> dictionaryElementList [
	^ optionalDictionaryElement , (dot , optionalDictionaryElement) star
]

{ #category : #accessing }
SysmelGrammar >> dictionaryExpression [
	^ sharp, lcbracket , dictionaryElementList , rcbracket
]

{ #category : #accessing }
SysmelGrammar >> dictionaryExpressionKey [
	^ expression , colon
]

{ #category : #accessing }
SysmelGrammar >> dictionaryKey [
	^ dictionaryKeywordKey / dictionaryExpressionKey
]

{ #category : #accessing }
SysmelGrammar >> dictionaryKeywordKey [
	^ keyword
]

{ #category : #tokens }
SysmelGrammar >> dot [
	^ self token: $. asPParser
]

{ #category : #accessing }
SysmelGrammar >> expression [
	^ commaExpression
]

{ #category : #accessing }
SysmelGrammar >> expressionList [
	^ optionalExpression, (dot , optionalExpression) star
]

{ #category : #tokens }
SysmelGrammar >> floatNumber [
	^ self token: self numberSign optional, #digit asPParser plus, $. asPParser , #digit asPParser plus , (self numberEMark , self numberSign optional, #digit asPParser plus) optional
]

{ #category : #tokens }
SysmelGrammar >> genericBinaryOperator [
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
SysmelGrammar >> greaterThan [
	^ self token: $> asPParser
]

{ #category : #tokens }
SysmelGrammar >> identifier [
	^ self token: self identifierStart , self identifierInner star , $: asPParser not
]

{ #category : #accessing }
SysmelGrammar >> identifierExpression [
	^ identifier
]

{ #category : #tokens }
SysmelGrammar >> identifierInner [
	^ #letter asPParser / #digit asPParser / $_ asPParser
]

{ #category : #tokens }
SysmelGrammar >> identifierStart [
	^ #letter asPParser / $_ asPParser
]

{ #category : #accessing }
SysmelGrammar >> implicitContextChainExpression [
	^ chainKeywordMessage , (semicolon , chainedMessage) star
]

{ #category : #accessing }
SysmelGrammar >> innerLiteralArrayLiteral [
	^ lparent , literalArrayLiteral star , rparent
]

{ #category : #tokens }
SysmelGrammar >> integerNumber [
	^ self token: self numberSign optional, #digit asPParser plus , ($r asPParser , (#letter asPParser / #digit asPParser) plus) optional
]

{ #category : #tokens }
SysmelGrammar >> keyword [
	^ self token: self identifierStart , self identifierInner star , $: asPParser
]

{ #category : #tokens }
SysmelGrammar >> keywordEnd [
	^ (self identifierStart / #digit asPParser ) not
]

{ #category : #tokens }
SysmelGrammar >> lbracket [
	^ self token: $[ asPParser
]

{ #category : #tokens }
SysmelGrammar >> lcbracket [
	^ self token: ${ asPParser
]

{ #category : #tokens }
SysmelGrammar >> lessThan [
	^ self token: $< asPParser
]

{ #category : #tokens }
SysmelGrammar >> litLParent [
	^ self token: '#(' asPParser
]

{ #category : #accessing }
SysmelGrammar >> literalArray [
	^ litLParent , literalArrayLiteral star , rparent
]

{ #category : #accessing }
SysmelGrammar >> literalArrayBinaryOperator [
	^ anyBinaryOperator
]

{ #category : #accessing }
SysmelGrammar >> literalArrayIdentifier [
	^ identifier
]

{ #category : #accessing }
SysmelGrammar >> literalArrayKeyword [
	^ self token: (self identifierStart , self identifierInner star , $: asPParser) plus
]

{ #category : #accessing }
SysmelGrammar >> literalArrayLiteral [
	^ literalArrayKeyword / literalArrayIdentifier / literalArrayBinaryOperator / innerLiteralArrayLiteral / literals
]

{ #category : #accessing }
SysmelGrammar >> literals [
	^ number / stringLiteral / characterLiteral / literalArray / symbolLiteral
]

{ #category : #'as yet unclassified' }
SysmelGrammar >> lowPrecedenceBinaryOperator [
	^ self operator: '::' asPParser , (PP2PredicateObjectNode anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #'as yet unclassified' }
SysmelGrammar >> lowPrecedenceExpression [
	^ anyChainExpression , (lowPrecedenceBinaryOperator , anyChainExpression) star
]

{ #category : #tokens }
SysmelGrammar >> lparent [
	^ self token: $( asPParser
]

{ #category : #white }
SysmelGrammar >> multiLineComment [
	^ ('/*' asPParser ,
		( ($* asPParser negate) /
			($* asPParser , $/ asPParser negate)
		) star ,
	'*/' asPParser token: SYMLCommentToken) ==> [ :t |
		t trimLeft: 2 right: 2
	]
]

{ #category : #white }
SysmelGrammar >> newline [
	^ String crlf asPParser / String cr asPParser / String lf asPParser
]

{ #category : #accessing }
SysmelGrammar >> number [
	^ floatNumber / integerNumber
]

{ #category : #tokens }
SysmelGrammar >> numberEMark [
	^ $e asPParser / $E asPParser
]

{ #category : #tokens }
SysmelGrammar >> numberSign [
	^ $+ asPParser / $- asPParser
]

{ #category : #operators }
SysmelGrammar >> operate: left with: right do: operation [
	^ { operation . left . right }
]

{ #category : #tokens }
SysmelGrammar >> operator: aParser [
	^ self token: aParser
]

{ #category : #'as yet unclassified' }
SysmelGrammar >> operatorString: aString [
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
SysmelGrammar >> optionalDictionaryElement [
	^ dictionaryElement optional
]

{ #category : #accessing }
SysmelGrammar >> optionalExpression [
	^ expression optional
]

{ #category : #accessing }
SysmelGrammar >> parentExpression [
	^ lparent , expression , rparent
]

{ #category : #operators }
SysmelGrammar >> postfix: operation operate: operand [
	^ { operation . operand }
]

{ #category : #accessing }
SysmelGrammar >> pragma [
	^ lessThan , pragmaChainedMessage , greaterThan
	
]

{ #category : #accessing }
SysmelGrammar >> pragmaChainKeywordMessage [
	^ (keyword , primaryExpression) plus
]

{ #category : #accessing }
SysmelGrammar >> pragmaChainUnaryMessage [
	^ anyIdentifier
]

{ #category : #accessing }
SysmelGrammar >> pragmaChainedMessage [
	^ pragmaChainKeywordMessage / pragmaChainUnaryMessage
]

{ #category : #operators }
SysmelGrammar >> prefix: operation operate: operand [
	^ { operation . operand }
]

{ #category : #accessing }
SysmelGrammar >> primaryExpression [
	^ quoteExpressions / parentExpression / identifierExpression / blockExpression / dictionaryExpression / literals
]

{ #category : #tokens }
SysmelGrammar >> quasiquote [
	^ self token: '``' asPParser
]

{ #category : #'macro operators' }
SysmelGrammar >> quasiquoteExpression [
	^ quasiquote , primaryExpression 
]

{ #category : #tokens }
SysmelGrammar >> quasiunquote [
	^ self token: '`,' asPParser
]

{ #category : #tokens }
SysmelGrammar >> quote [
	^ self token: '`''' asPParser
]

{ #category : #'macro operators' }
SysmelGrammar >> quoteExpression [
	^ quote , primaryExpression 
]

{ #category : #'macro operators' }
SysmelGrammar >> quoteExpressions [
	^ quoteExpression / quasiquoteExpression / unquoteExpression / spliceExpression
]

{ #category : #tokens }
SysmelGrammar >> rbracket [
	^ self token: $] asPParser
]

{ #category : #tokens }
SysmelGrammar >> rcbracket [
	^ self token: $} asPParser
]

{ #category : #tokens }
SysmelGrammar >> rparent [
	^ self token: $) asPParser
]

{ #category : #accessing }
SysmelGrammar >> semicolon [
	^ self token: $; asPParser
]

{ #category : #tokens }
SysmelGrammar >> sharp [
	^ self token: $# asPParser 
]

{ #category : #white }
SysmelGrammar >> singleLineComment [
	^ ('//' asPParser, self newline negate star, self newline token: SYMLCommentToken) ==> [ :t |
		t trimLeft: 2
	]
]

{ #category : #white }
SysmelGrammar >> spaces [
	^ #space asPParser plus ==> [ :t | #() ]
]

{ #category : #tokens }
SysmelGrammar >> splice [
	^ self token: '`@' asPParser
]

{ #category : #'macro operators' }
SysmelGrammar >> spliceExpression [
	^ splice , primaryExpression
]

{ #category : #accessing }
SysmelGrammar >> start [
	^ self whites, expressionList , self whites, #endOfInput asPParser
]

{ #category : #accessing }
SysmelGrammar >> stringLiteral [
	^ self token: $" asPParser , ($" asPParser negate / ($\ asPParser , #any asPParser)) star , $" asPParser
]

{ #category : #accessing }
SysmelGrammar >> symbolIdentifierLiteral [
	^ self token: $# asPParser , self identifierStart , self identifierInner star
]

{ #category : #accessing }
SysmelGrammar >> symbolKeywordLiteral [
	^ self token: $# asPParser, (self identifierStart , self identifierInner star , $: asPParser) plus
]

{ #category : #'as yet unclassified' }
SysmelGrammar >> symbolLiteral [
	^ symbolKeywordLiteral / symbolOperatorLiteral / symbolIdentifierLiteral / symbolStringLiteral
]

{ #category : #accessing }
SysmelGrammar >> symbolOperatorLiteral [
	^ self token: $# asPParser , (PP2PredicateObjectNode anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #accessing }
SysmelGrammar >> symbolStringLiteral [
	^ self token: '#"' asPParser , ($" asPParser negate / ($\ asPParser , #any asPParser)) star , $" asPParser
]

{ #category : #tokens }
SysmelGrammar >> token: aParser [
	"^ (aParser token: SYMLToken) trim: self whites"
	^ (self whites , (aParser token: SysmelToken)) ==> [ :parts |
			parts second
				previousComments: parts first;
				yourself
	]
]

{ #category : #accessing }
SysmelGrammar >> unaryExpression [
	^ primaryExpression , unaryExpressionSuffix star
]

{ #category : #accessing }
SysmelGrammar >> unaryExpressionSuffix [
	^ unaryExpressionSuffixMessage / unaryExpressionSuffixCall / unarySuffixSubscript / unaryExpressionSuffixUnquote
]

{ #category : #accessing }
SysmelGrammar >> unaryExpressionSuffixCall [
	^ lparent , callExpressionArguments , rparent
]

{ #category : #accessing }
SysmelGrammar >> unaryExpressionSuffixMessage [
	^ anyIdentifier
]

{ #category : #accessing }
SysmelGrammar >> unaryExpressionSuffixUnquote [
	^ unquoteExpression
]

{ #category : #accessing }
SysmelGrammar >> unarySuffixSubscript [
	^ lbracket , expression , rbracket
]

{ #category : #'macro operators' }
SysmelGrammar >> unquoteExpression [
	^ quasiunquote , primaryExpression
]

{ #category : #tokens }
SysmelGrammar >> verticalBar [
	^ self token: $| asPParser
]

{ #category : #white }
SysmelGrammar >> white [
	^ self singleLineComment / self multiLineComment / self spaces
]

{ #category : #white }
SysmelGrammar >> whites [
	^ self white star
]
