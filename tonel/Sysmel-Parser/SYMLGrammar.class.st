Class {
	#name : #SYMLGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'expression',
		'optionalExpression',
		'semicolon',
		'white',
		'singleLineComment',
		'multiLineComment',
		'newline',
		'identStart',
		'expressionList',
		'identifier',
		'keywordEnd',
		'whites',
		'spaces',
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
		'identifierStart',
		'identifierInner',
		'parentExpression',
		'identifierExpression',
		'anyChainExpression',
		'implicitContextChainExpression',
		'numberSign',
		'numberEMark',
		'floatNumber',
		'integerNumber',
		'number',
		'literals',
		'commaExpression',
		'pragmaChainKeywordMessage',
		'lbracketbracket',
		'pragmaChainedMessage',
		'rbracketbracket',
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
		'scapedLanguageContent',
		'lbracket',
		'rbracket',
		'literalArrayKeyword',
		'lowPrecedenceBinaryOperator',
		'lowPrecedenceExpression',
		'unarySuffixSubscript'
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
	^ self operator: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #accessing }
SYMLGrammar >> anyChainExpression [
	^ implicitContextChainExpression / chainExpression
]

{ #category : #accessing }
SYMLGrammar >> anyIdentifier [
	^ (self token: identifierStart ,  identifierInner star , $: asParser not)
]

{ #category : #tokens }
SYMLGrammar >> assignOperator [
	^ self operator: ':=' asParser
]

{ #category : #accessing }
SYMLGrammar >> assignmentExpression [
	^ lowPrecedenceExpression , (assignOperator , assignmentExpression) optional
]

{ #category : #accessing }
SYMLGrammar >> binaryExpression [
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
	^ self token: $' asParser , ($' asParser negate / ($\ asParser , #any asParser)) star , $' asParser
]

{ #category : #accessing }
SYMLGrammar >> colon [
	^ self token: $: asParser
]

{ #category : #tokens }
SYMLGrammar >> comma [
	^ self token: $, asParser
]

{ #category : #accessing }
SYMLGrammar >> commaExpression [
	^ assignmentExpression , (comma, assignmentExpression) star, comma optional
]

{ #category : #tokens }
SYMLGrammar >> dot [
	^ self token: $. asParser
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
	^ self token: numberSign optional, #digit asParser plus, $. asParser , #digit asParser plus , (numberEMark , numberSign optional, #digit asParser plus) optional
]

{ #category : #tokens }
SYMLGrammar >> genericBinaryOperator [
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
]

{ #category : #tokens }
SYMLGrammar >> identStart [
	^ #letter asParser / $_ asParser
]

{ #category : #tokens }
SYMLGrammar >> identifier [
	^ self token: identifierStart ,  identifierInner star , $: asParser not
]

{ #category : #accessing }
SYMLGrammar >> identifierExpression [
	^ identifier
]

{ #category : #tokens }
SYMLGrammar >> identifierInner [
	^ #letter asParser / #digit asParser / $_ asParser
]

{ #category : #tokens }
SYMLGrammar >> identifierStart [
	^ #letter asParser / $_ asParser
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
	^ self token: numberSign optional, #digit asParser plus
]

{ #category : #tokens }
SYMLGrammar >> keyword [
	^ self token: identifierStart , identifierInner star , $: asParser
]

{ #category : #accessing }
SYMLGrammar >> keyword: aKeyword [
	^ (aKeyword asParser , keywordEnd) token trim: white
]

{ #category : #tokens }
SYMLGrammar >> keywordEnd [
	^ (identStart / #digit asParser ) not
]

{ #category : #accessing }
SYMLGrammar >> languageScapeExpression [
	^ languageScapeOperator , identifier , (self token: scapedLanguageContent)
]

{ #category : #tokens }
SYMLGrammar >> languageScapeOperator [
	^ self token: '$$' asParser
]

{ #category : #tokens }
SYMLGrammar >> lbracket [
	^ self token: $[ asParser
]

{ #category : #tokens }
SYMLGrammar >> lbracketbracket [
	^ self token: '[[' asParser
]

{ #category : #tokens }
SYMLGrammar >> lcbracket [
	^ self token: ${ asParser
]

{ #category : #tokens }
SYMLGrammar >> litLParent [
	^ self token: '#(' asParser
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
	^ self token: (identifierStart , identifierInner star , $: asParser) plus
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
	^ self operator: '::' asParser , (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> lowPrecedenceExpression [
	^ anyChainExpression , (lowPrecedenceBinaryOperator , anyChainExpression) star
]

{ #category : #tokens }
SYMLGrammar >> lparent [
	^ self token: $( asParser
]

{ #category : #white }
SYMLGrammar >> multiLineComment [
	^ '/*' asParser ,
		( ($* asParser negate) /
			($* asParser , $/ asParser negate)
		) star ,
	'*/' asParser
]

{ #category : #white }
SYMLGrammar >> newline [
	^ String crlf asParser / String cr asParser / String lf asParser
]

{ #category : #accessing }
SYMLGrammar >> number [
	^ floatNumber / integerNumber
]

{ #category : #tokens }
SYMLGrammar >> numberEMark [
	^ $e asParser / $E asParser
]

{ #category : #tokens }
SYMLGrammar >> numberSign [
	^ $+ asParser / $- asParser
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
		(result isPetitFailure not and: [ result inputValue ~= aString]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected a special operator' context: stream
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
	^ lbracketbracket , pragmaChainedMessage, rbracketbracket
]

{ #category : #accessing }
SYMLGrammar >> pragmaChainKeywordMessage [
	^ (keyword , primaryExpression) plus
]

{ #category : #accessing }
SYMLGrammar >> pragmaChainUnaryMessage [
	^ chainUnaryMessage
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
	^ languageScapeExpression / parentExpression / identifierExpression / blockExpression / literals
]

{ #category : #tokens }
SYMLGrammar >> rbracket [
	^ self token: $] asParser
]

{ #category : #tokens }
SYMLGrammar >> rbracketbracket [
	^ self token: ']]' asParser
]

{ #category : #tokens }
SYMLGrammar >> rcbracket [
	^ self token: $} asParser
]

{ #category : #tokens }
SYMLGrammar >> rparent [
	^ self token: $) asParser
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> scapeLanguageContentOpen: openCharacter close: closeCharacter [
	^ SYMLScapedLanguageParser new openCharacter: openCharacter; closeCharacter: closeCharacter; yourself
]

{ #category : #accessing }
SYMLGrammar >> scapedLanguageContent [
	^ (self scapeLanguageContentOpen: $[ close: $]) /
		(self scapeLanguageContentOpen: $( close: $)) /
		(self scapeLanguageContentOpen: ${ close: $})
]

{ #category : #accessing }
SYMLGrammar >> semicolon [
	^ self token: $; asParser
]

{ #category : #white }
SYMLGrammar >> singleLineComment [
	^ '//' asParser, newline negate star, newline
]

{ #category : #white }
SYMLGrammar >> spaces [
	^ #space asParser plus
]

{ #category : #accessing }
SYMLGrammar >> start [
	^ whites, expressionList , whites, #eof asParser
]

{ #category : #accessing }
SYMLGrammar >> stringLiteral [
	^ self token: $" asParser , ($" asParser negate / ($\ asParser , #any asParser)) star , $" asParser
]

{ #category : #accessing }
SYMLGrammar >> symbolIdentifierLiteral [
	^ self token: $# asParser , identifierStart , identifierInner star
]

{ #category : #accessing }
SYMLGrammar >> symbolKeywordLiteral [
	^ self token: $# asParser, (identifierStart , identifierInner star , $: asParser) plus
]

{ #category : #'as yet unclassified' }
SYMLGrammar >> symbolLiteral [
	^ symbolKeywordLiteral / symbolOperatorLiteral / symbolIdentifierLiteral / symbolStringLiteral
]

{ #category : #accessing }
SYMLGrammar >> symbolOperatorLiteral [
	^ self token: $# asParser , (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #accessing }
SYMLGrammar >> symbolStringLiteral [
	^ self token: '#"' asParser , ($" asParser negate / ($\ asParser , #any asParser)) star , $" asParser
]

{ #category : #tokens }
SYMLGrammar >> token: aParser [
	^ (whites , aParser token) ==> [ :parts | parts second ]
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

{ #category : #white }
SYMLGrammar >> white [
	^ singleLineComment / multiLineComment / spaces
]

{ #category : #white }
SYMLGrammar >> whites [
	^ white star
]
