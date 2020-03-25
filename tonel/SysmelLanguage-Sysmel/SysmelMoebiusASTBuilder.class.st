Class {
	#name : #SysmelMoebiusASTBuilder,
	#superclass : #SysmelAbstractASTNodeVisitor,
	#instVars : [
		'collectionWithContext',
		'builder'
	],
	#classVars : [
		'CScapeCharacter'
	],
	#category : #'SysmelLanguage-Sysmel-IRAST'
}

{ #category : #'class initialization' }
SysmelMoebiusASTBuilder class >> initialize [
	CScapeCharacter := Dictionary newFromPairs: { 
		$a . 16r07 asCharacter.
		$b . 16r08 asCharacter.
		$f . 16r0c asCharacter.
		$n . Character lf.
		$r . Character cr.
		$t . Character tab.
		$v . 16r0b asCharacter.
		$' . $'.
		$" . $".
		$\ . $\.
	}.
]

{ #category : #accessing }
SysmelMoebiusASTBuilder >> builder [
	^ builder
]

{ #category : #accessing }
SysmelMoebiusASTBuilder >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
SysmelMoebiusASTBuilder >> collectionWithContext [
	^ collectionWithContext
]

{ #category : #accessing }
SysmelMoebiusASTBuilder >> collectionWithContext: anObject [
	collectionWithContext := anObject
]

{ #category : #'as yet unclassified' }
SysmelMoebiusASTBuilder >> convertNode: aNode [
	^ aNode acceptVisitor: self
]

{ #category : #'as yet unclassified' }
SysmelMoebiusASTBuilder >> convertNodePosition: node [
	| startPosition stopPosition |
	startPosition := node startPosition.
	self assert: startPosition ~~ SmallInteger maxVal.
	stopPosition := node stopPosition.
	^ MbndSourcePosition new
		collection: collectionWithContext;
		start: startPosition;
		stop: stopPosition;
		yourself
]

{ #category : #'as yet unclassified' }
SysmelMoebiusASTBuilder >> convertTokenPosition: token [
	^ MbndSourcePosition new
		collection: collectionWithContext;
		start: token startPosition;
		stop: token stopPosition;
		yourself
]

{ #category : #parsing }
SysmelMoebiusASTBuilder >> parseCCharacter: aString [
	| in c |
	^ (ByteArray streamContents: [ :out |
		in := ReadStream on: aString from: 2 to: aString size - 1 .
		[in atEnd] whileFalse: [
			c := in next.
			c = $\ ifTrue: [
				self parseCEscapeSequenceFrom: in into: out
			] ifFalse: [
				out nextPut: c asInteger
			]
		].
	]) first
]

{ #category : #parsing }
SysmelMoebiusASTBuilder >> parseCEscapeSequenceFrom: in into: out [
	| c codePoint |
	c := in next.
	CScapeCharacter at: c ifPresent: [ :v |
		out nextPut: v asInteger.
		^ self
	].

	"Hex"
	c = $x ifTrue: [
		codePoint := Integer readFrom: (in next: 2) base: 16.
		out nextPut: codePoint.
		^ self
	].

	"Octal"
	c isDigit ifTrue: [
		codePoint := Integer readFrom: c asString , (in next: 2) base: 8.
		out nextPut: codePoint.
		^ self
	].

	self error: 'Unsupported C escape character ' , c asString
]

{ #category : #parsing }
SysmelMoebiusASTBuilder >> parseCString: aString [
	| in c |
	^ (ByteArray streamContents: [ :out |
		in := ReadStream on: aString from: 2 to: aString size - 1 .
		[in atEnd] whileFalse: [
			c := in next.
			c = $\ ifTrue: [
				self parseCEscapeSequenceFrom: in into: out
			] ifFalse: [
				out nextPut: c asInteger
			]
		].
	]) utf8Decoded
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> validateMessageSendKeyword: keywordToken [
	| keyword hasSeenColon |
	keyword := keywordToken value.
	
	"To facilitate the scanner for literal array, we accept first:second: as a keyword here which is not allowed"
	hasSeenColon := false.
	keyword do: [ :eachCharacter |
		eachCharacter = $: ifTrue: [
			hasSeenColon ifTrue: [
				MbndParseError new
					sourcePosition: (self convertTokenPosition: keywordToken);
					signal: ('Invalid message send composite keyword "{1}".' format: {keyword})
			] ifFalse: [
				hasSeenColon := true
			]
		]
	].

	^ keyword
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitAbstract: node [
	self shouldNotImplement
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitBinaryExpression: binaryExpression [
	| left right selectorSymbol selector |
	left := self convertNode: binaryExpression left.
	right := self convertNode: binaryExpression right.
	selectorSymbol := binaryExpression operation value asSymbol.
	(selectorSymbol beginsWith: #'::') ifTrue: [
		selectorSymbol := (selectorSymbol allButFirst: 2) asSymbol
	].

	selectorSymbol == #':=' ifTrue: [
		selectorSymbol := #assignValue:
	].
	
	selector := (builder literalSymbol: selectorSymbol)
		position: (self convertTokenPosition: binaryExpression operation);
		yourself.
	^ (builder unexpandedSend: selector to: left withArguments: { right })
		position: (self convertNodePosition: binaryExpression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitBlockClosureArgument: argumentNode [
	^ (builder argument: (self convertNode: argumentNode name) type: (argumentNode type ifNotNil: [:t | self convertNode: t]))
		position: (self convertNodePosition: argumentNode);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitBlockClosureSignature: literalString [
	self shouldNotImplement
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitBlockExpression: blockExpression [
	| body arguments returnType |
	body := (self convertNode: blockExpression expressions) copy
		pragmas: (blockExpression pragmas collect: [:each | self convertNode: each] as: Array);
		yourself.

	blockExpression blockClosureSignature ifNil: [
		^ body
			position: (self convertNodePosition: blockExpression);
			lexicallyScoped
	].

	arguments := blockExpression blockClosureSignature arguments collect: [ :each | self convertNode: each ] as: Array.
	returnType := blockExpression blockClosureSignature returnType ifNotNil: [ :rt | self convertNode: rt ].
	^ (builder blockClosure: body arguments: arguments returnType: returnType)
		position: (self convertNodePosition: blockExpression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitCallExpression: expression [
	| function arguments position selector |
	function := self convertNode: expression function.
	arguments := self convertNode: expression arguments.
	position := self convertNodePosition: expression.
	selector := (builder literalSymbol: #applyWithArguments:)
		position: position.
	^ (builder unexpandedSend: selector to: function withArguments: {arguments})
		position: position
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitCallExpressionArguments: arguments [
	| result |
	result := builder tuple: (arguments arguments collect: [:each | self convertNode: each] as: Array).
	result elements ifNotEmpty: [ result position: (self convertNodePosition: arguments) ].
	^ result
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitCommaExpression: commaExpression [
	| elements |
	elements := commaExpression expressions collect: [ :each | self convertNode: each ] as: Array.
	^ (builder tuple: elements)
		position: (self convertNodePosition: commaExpression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitDictionaryElement: dictionaryElement [
	^ (builder associationKey: (self convertNode: dictionaryElement key) value: (dictionaryElement value ifNotNil: [:vn | self convertNode: vn]))
		position: (self convertNodePosition: dictionaryElement);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitDictionaryExpression: dictionaryExpression [
	^ (builder dictionary: (dictionaryExpression elements collect: [:each | self convertNode: each]))
		position: (self convertNodePosition: dictionaryExpression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitDictionaryKey: dictionaryKey [
	^ self convertNode: dictionaryKey value
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitDictionaryKeywordKey: aDictionaryKeywordKey [
	| keyword |
	keyword := self validateMessageSendKeyword: aDictionaryKeywordKey value.
	^ (builder literalSymbol: keyword allButLast asSymbol)
		position: (self convertTokenPosition: aDictionaryKeywordKey value)
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitExpressionList: node [
	| result |
	result := (builder sequence: (node expressions select: [ :each | each isNotNil ] thenCollect: [:each | self convertNode: each] ) asArray).
	node expressions ifNotEmpty: [ result position: (self convertNodePosition: node) ].
	^ result
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitFile: node [
	^ self convertNode: node expressionList
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitIdentifierReference: identifier [
	^ (builder identifier: identifier symbol value asSymbol)
		position: (self convertTokenPosition: identifier symbol);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitKeywordMessage: keywordMessage [
	| selectorString selector arguments |
	selectorString := ByteString streamContents: [ :out |
		keywordMessage keywords do: [ :each |
			out nextPutAll: (self validateMessageSendKeyword: each)
		]
	].

	selector := (builder literalSymbol: selectorString asSymbol)
		position: (self convertTokenPosition: keywordMessage keywords first);
		yourself.
	arguments := keywordMessage arguments collect: [ :each | self convertNode: each ] as: Array.
	^ (builder messageChainMessageSelector: selector arguments: arguments)
		position: (self convertNodePosition: keywordMessage);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitLiteralArray: literalArrayExpression [
	| elements |
	elements := literalArrayExpression elements collect: [:each | (self convertNode: each) value] as: Array.
	^ (builder literalArray: elements)
		position: (self convertNodePosition: literalArrayExpression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitLiteralCharacter: literalCharacter [
	^ (builder literalCharacter: (self parseCCharacter: literalCharacter value value))
		position: (self convertTokenPosition: literalCharacter value);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitLiteralFloat: literalFloat [
	| floatString |
	floatString := literalFloat value value.
	(floatString beginsWith: '+') ifTrue: [ floatString := floatString allButFirst ].
	^ (builder literalFloat: floatString asNumber asFloat)
		position: (self convertTokenPosition: literalFloat value);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitLiteralInteger: literalInteger [
	| integerString |
	integerString := literalInteger value value.
	(integerString beginsWith: '+') ifTrue: [ integerString := integerString allButFirst ].
	^ (builder literalInteger: integerString asNumber)
		position: (self convertTokenPosition: literalInteger value);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitLiteralString: literalString [
	^ (builder literalString: (self parseCString: literalString value value))
		position: (self convertTokenPosition: literalString value);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitLiteralSymbol: literalSymbol [
	| literalSymbolValue |
	literalSymbolValue := literalSymbol value value.
	(literalSymbolValue beginsWith: '#') ifTrue: [ literalSymbolValue := literalSymbolValue allButFirst ].
	(literalSymbolValue beginsWith: '"') ifTrue: [ literalSymbolValue := self parseCString: literalSymbolValue ].
	^ (builder literalSymbol: literalSymbolValue asSymbol)
		position: (self convertTokenPosition: literalSymbol value);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitMessageChain: node [
	| receiver allChainedMessages |
	receiver := node receiver ifNotNil: [self convertNode: node receiver].
	node chainedMessages ifEmpty: [ 
		node firstMessage ifNil: [
			self assert: receiver isNotNil.
			^ receiver
		].
	
		^ (self convertNode: node firstMessage) asUnexpandedMessageSend
			receiver: receiver;
			yourself
	].

	allChainedMessages := Array streamContents: [ :out |
		node firstMessage ifNil: [
			(receiver isNil or: [ receiver isUnexpandedMessageSendNode not ]) ifTrue: [
				^ MbndParseError new
					sourcePosition: (self convertNodePosition: node);
					signal: 'Invalid message chain.'
			].
			out nextPut: ((builder messageChainMessageSelector: receiver selector arguments: receiver arguments)
				position: receiver position).
			receiver := receiver receiver.
		] ifNotNil: [
			out nextPut: (self convertNode: node firstMessage)
		].
	
		node chainedMessages do: [ :each | out nextPut: (self convertNode: each) ]
	].

	^ (builder messageChainReceiver: receiver messages: allChainedMessages)
		position: (self convertNodePosition: node);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitParenthesesExpression: expression [
	expression expression ifNotNil: [ ^ self convertNode: expression expression ].
	^ (builder tuple: #())
		position: (self convertNodePosition: expression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitPragma: pragmaNode [
	| pragmaMessage |
	pragmaMessage := self convertNode: pragmaNode message.
	^ (builder pragmaSelector: pragmaMessage selector value arguments: pragmaMessage arguments)
		position: (self convertNodePosition: pragmaNode);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitQuasiQuoteExpression: expression [
	^ (builder quasiQuote: (self convertNode: expression expression))
		position: (self convertNodePosition: expression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitQuasiUnquoteExpression: expression [
	^ (builder quasiUnquote: (self convertNode: expression expression))
		position: (self convertNodePosition: expression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitQuoteExpression: expression [
	^ (builder quote: (self convertNode: expression expression))
		position: (self convertNodePosition: expression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitSpliceExpression: expression [
	^ (builder splice: (self convertNode: expression expression))
		position: (self convertNodePosition: expression);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitSubscriptExpression: expression [
	| array subscript selector |
	array := self convertNode: expression array.
	subscript := self convertNode: expression subscript.
	selector := (builder literalSymbol: #subscriptAt:)
		position: (self convertNodePosition: expression).
	^ (builder unexpandedSend: selector to: array withArguments: { subscript })
		position: selector position;
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitUnaryMessage: unaryMessage [
	| selector |
	selector := (builder literalSymbol: unaryMessage selector value asSymbol)
		position: (self convertTokenPosition: unaryMessage selector);
		yourself.
	^ (builder unexpandedSend: selector to: (unaryMessage receiver ifNotNil: [self convertNode: unaryMessage receiver]) withArguments: #())
		position: (self convertNodePosition: unaryMessage);
		yourself
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitUnaryPrefixExpression: prefixExpression [
	| operand operation selectorSymbol selector |
	operand := self convertNode: prefixExpression operand.
	operation := prefixExpression operation value.

	selectorSymbol := ('prefix-' , operation) asSymbol.
	selector := (builder literalSymbol: selectorSymbol)
		position: (self convertTokenPosition: prefixExpression operation);
		yourself.

	^ builder unexpandedSend: selector to: operand withArguments: #()
]

{ #category : #visitor }
SysmelMoebiusASTBuilder >> visitUnquoteUnaryMessage: unquoteUnaryMessage [
	| receiver selector |
	receiver := self convertNode: unquoteUnaryMessage receiver.
	selector := (builder quasiUnquote: (self convertNode: unquoteUnaryMessage selector))
		position: (self convertTokenPosition: unquoteUnaryMessage operator).
	^ (builder unexpandedSend: selector to: receiver withArguments: #())
		position: (self convertNodePosition: unquoteUnaryMessage)
]
