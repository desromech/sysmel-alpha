Class {
	#name : #SYMLParser,
	#superclass : #SYMLGrammar,
	#classVars : [
		'CScapeCharacter'
	],
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #initialization }
SYMLParser class >> initialize [
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
	
	SYMLModule registerParser: self forExtension: 'sysmel'.
	
]

{ #category : #accessing }
SYMLParser >> assignmentExpression [
	^ super assignmentExpression ==> [ :list |
		list second ifNotNil: [
			SYMLASTAssignment new
				position: list second first;
				reference: list first;
				value: list second second;
				yourself
		] ifNil: [
			list first
		]
	]
]

{ #category : #accessing }
SYMLParser >> blockExpression [
	^ super blockExpression ==> [ :tokens |
		SYMLASTBlock new
			tokens: { tokens first . tokens last };
			position: tokens first;
			pragmas: tokens second;
			expressions: tokens third;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> callExpressionArguments [
	^ super callExpressionArguments ==> [ :tokens | tokens ifNil: [ SYMLASTCommaSeparatedList new expressions: #() ]  ]
]

{ #category : #accessing }
SYMLParser >> chainExpression [
	^ super chainExpression ==> [ :list |
		list third ifEmpty: [
			list second ifNil: [
				list first
			] ifNotNil: [
				list second copy receiver: list first
			]
		] ifNotEmpty: [
			| position chained |
			position := list third first first.
			chained := list third collect: #second.
			list second ifNil: [
				list first isMessageSend ifFalse: [ 
					PPFailure message: 'a chain has to start with a message send'
				] ifTrue: [
					SYMLASTMessageChain new
						position: position;
						receiver: list first receiver;
						messages: { list first copy receiver: nil; yourself } , chained;
						yourself
				]
			] ifNotNil: [
				SYMLASTMessageChain new
					position: position;
					receiver: list first;
					messages: { list second } , chained;
					yourself
			]
		]
	]
]

{ #category : #accessing }
SYMLParser >> chainKeywordMessage [
	^ super chainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		SYMLASTMessageSend new
			position: list first first;
			tokens: (list collect: #first);
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> chainUnaryMessage [
	^ super chainUnaryMessage ==> [ :selector |
		SYMLASTMessageSend new
			tokens: {selector};
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> characterLiteral [
	^ super characterLiteral ==> [ :token |
		SYMLASTLiteralCharacterValue new
			tokens: { token };
			position: token;
			value: (self parseCCharacter: token inputValue);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> commaExpression [
	^ super commaExpression ==> [ :list |
		(list second isEmpty and: [list last isNil]) ifTrue: [ list first ]
		ifFalse: [
			SYMLASTCommaSeparatedList new
				position: list first;
				expressions: {list first} , (list second collect: #second);
				yourself
		]
	]
]

{ #category : #accessing }
SYMLParser >> expressionList [
	^ super expressionList ==> [ :list |
		({ list first } , (list second collect: #second)) select: #isNotNil
	]
]

{ #category : #accessing }
SYMLParser >> floatNumber [
	^ super floatNumber ==> [ :token | SYMLASTLiteralFloatValue new
			tokens: { token };
			position: token;
			value: (self parseFloatValue: token inputValue);
			yourself
			]
]

{ #category : #accessing }
SYMLParser >> identifierExpression [
	^ super identifierExpression ==> [ :token |
		SYMLASTIdentifierReference new
			position: token;
			tokens: { token };
			value: token inputValue asSymbol;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> implicitContextChainExpression [
	^ super implicitContextChainExpression ==> [ :list |
		list second ifEmpty: [
			list first
		] ifNotEmpty: [
			| position chained |
			position := list second first first.
			chained := list second collect: #second.

			SYMLASTMessageChain new
				position: position;
				messages: { list first } , chained;
				yourself
		]
	]
]

{ #category : #accessing }
SYMLParser >> innerLiteralArrayLiteral [
	^ super innerLiteralArrayLiteral ==> [ :tokens |
		SYMLASTLiteralArrayValue new
			tokens: { tokens first . tokens last  };
			position: tokens first;
			elements: tokens second;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> integerNumber [
	^ super integerNumber ==> [ :token | SYMLASTLiteralIntegerValue new
			tokens: { token };
			position: token;
			value: (self parseIntegerValue: token inputValue);
			yourself
			]
]

{ #category : #accessing }
SYMLParser >> languageScapeExpression [
	^ super languageScapeExpression ==> [ :tokens |
		SYMLASTLanguageScape new
			tokens: { tokens };
			position: tokens first;
			languageName: tokens second inputValue asSymbol;
			sourceCode: tokens third inputValue;
			sourceCodePosition: tokens third;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> literalArray [
	^ super literalArray ==> [ :tokens |
		SYMLASTLiteralArrayValue new
			tokens: { tokens first . tokens last  };
			position: tokens first;
			elements: tokens second;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> literalArrayBinaryOperator [
	^ super literalArrayBinaryOperator ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> literalArrayIdentifier [
	^ super literalArrayIdentifier ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> literalArrayKeyword [
	^ super literalArrayKeyword ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> lowPrecedenceExpression [
	^ super lowPrecedenceExpression ==> [ :list |
		| result|
		result := list first.
		list second do: [ :nextExpression |
			result := SYMLASTMessageSend new
				position: nextExpression first;
				selector: (nextExpression first inputValue allButFirst: 2) asSymbol;
				receiver: result;
				arguments: { nextExpression second };
				yourself.
		].
	
		result
	]
]

{ #category : #accessing }
SYMLParser >> multiLineComment [
	^ super multiLineComment flatten ==> [ :data | data copyFrom: 3 to: data size - 2 ]
]

{ #category : #accessing }
SYMLParser >> operate: left with: right do: operation [
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: operation inputValue asSymbol;
		receiver: left;
		arguments: {right};
		yourself

]

{ #category : #accessing }
SYMLParser >> parentExpression [
	^ super parentExpression ==> [ :tokens |
		SYMLASTParentExpression new
			position: tokens first;
			tokens: { tokens first . tokens last };
			expression: tokens second;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> parseCEscapeSequenceFrom: in into: out [
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

{ #category : #accessing }
SYMLParser >> parseCString: aString [
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

{ #category : #accessing }
SYMLParser >> parseFloatValue: aString [
	^ (aString first = $+ ifTrue: [ aString allButFirst ] ifFalse: [ aString ]) asNumber asFloat
]

{ #category : #accessing }
SYMLParser >> parseIntegerValue: aString [
	^ (aString first = $+ ifTrue: [ aString allButFirst ] ifFalse: [ aString ]) asInteger
]

{ #category : #accessing }
SYMLParser >> postfix: operation operate: operand [
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: ('postfix-' , operation inputValue) asSymbol;
		receiver: operand;
		arguments: #();
		yourself

]

{ #category : #accessing }
SYMLParser >> prefix: operation operate: operand [
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: ('prefix-' , operation inputValue) asSymbol;
		receiver: operand;
		arguments: #();
		yourself

]

{ #category : #accessing }
SYMLParser >> singleLineComment [
	^ super singleLineComment flatten ==> [ :data | data allButFirst: 2 ]
]

{ #category : #accessing }
SYMLParser >> spaces [
	^ super spaces ==> [ :data | nil ]
]

{ #category : #accessing }
SYMLParser >> start [
	^ super start ==> [ :tokens |
		SYMLASTFile new
			headerComments: tokens first;
			expressions: tokens second;
			footerComments: tokens third;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> stringLiteral [
	^ super stringLiteral ==> [ :token |
		SYMLASTLiteralStringValue new
			tokens: { token };
			position: token;
			value: (self parseCString: token inputValue);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> symbolIdentifierLiteral [
	^ super symbolIdentifierLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> symbolKeywordLiteral [
	^ super symbolKeywordLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> symbolOperatorLiteral [
	^ super symbolOperatorLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> symbolStringLiteral [
	^ super symbolStringLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (self parseCString: token inputValue allButFirst) asSymbol;
			yourself
	]
]

{ #category : #tokens }
SYMLParser >> token: aParser [
	^ (whites, (aParser token: SYMLToken)) ==> [ :parts |
		parts second
			previousComments: parts first;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> unaryExpression [
	^ super unaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :postfix |
			result := postfix withReceiver: result
		].
		result
	]
]

{ #category : #accessing }
SYMLParser >> unaryExpressionSuffixCall [
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		SYMLASTFunctionApplication new
			position: tokens first;
			tokens: { tokens first . tokens last };
			arguments: tokens second;
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> unaryExpressionSuffixMessage [
	^ super unaryExpressionSuffixMessage ==> [ :selector |
		SYMLASTMessageSend new
			position: selector;
			tokens: { selector };
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]
]

{ #category : #accessing }
SYMLParser >> unarySuffixSubscript [
	^ super unarySuffixSubscript ==> [ :tokens |
		SYMLASTSubscriptExpression new
			position: tokens first;
			tokens: { tokens first . tokens last };
			index: tokens second;
			yourself
	]
]
