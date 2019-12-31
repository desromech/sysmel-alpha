Class {
	#name : #SysmelParser,
	#superclass : #SysmelGrammar,
	#classVars : [
		'CScapeCharacter',
		'OptimizedParser'
	],
	#category : #'SysmelLanguage-Sysmel-Parser'
}

{ #category : #initialization }
SysmelParser class >> initialize [
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
	self optimizedParser
]

{ #category : #initialization }
SysmelParser class >> noteCompilationOf: aSelector meta: isMeta [
	OptimizedParser := nil
]

{ #category : #initialization }
SysmelParser class >> optimizedParser [
	^ OptimizedParser ifNil: [ OptimizedParser := self new optimize ]
]

{ #category : #accessing }
SysmelParser >> assignmentExpression [
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
SysmelParser >> blockClosureArgument [
	^ super blockClosureArgument ==> [:tokens |
		SYMLASTBlockArgument new
			position: tokens first;
			name: tokens third;
			optionalType: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> blockClosureReturnType [
	^ super blockClosureReturnType ==> [ :tokens |
		tokens third
	]
]

{ #category : #accessing }
SysmelParser >> blockClosureSignature [
	^ super blockClosureSignature ==> [ :tokens |
		SYMLASTBlockSignature new
			position: (tokens first ifEmpty: [ tokens last ] ifNotEmpty: [tokens first first]);
			arguments: tokens first;
			returnType: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> blockExpression [
	^ super blockExpression ==> [ :tokens |
		tokens second ifNotNil: [ 
			SYMLASTBlockClosure new
				tokens: { tokens first . tokens last };
				position: tokens first;
				signature: tokens second;
				pragmas: tokens third;
				expressions: tokens fourth;
				yourself
		] ifNil: [ 
			SYMLASTBlock new
				tokens: { tokens first . tokens last };
				position: tokens first;
				pragmas: tokens third;
				expressions: tokens fourth;
				yourself
		]
	]
]

{ #category : #accessing }
SysmelParser >> callExpressionArguments [
	^ super callExpressionArguments ==> [ :tokens | tokens ifNil: [ SYMLASTCommaSeparatedList new expressions: #() ]  ]
]

{ #category : #accessing }
SysmelParser >> chainExpression [
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
				list first isMessageNode ifFalse: [ 
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
SysmelParser >> chainKeywordMessage [
	^ super chainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		SYMLASTMessageSend new
			position: list first first;
			tokens: (list collect: #first) asArray;
			selector: selector asSymbol;
			arguments: (list collect: #second) asArray;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> chainUnaryMessage [
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
SysmelParser >> characterLiteral [
	^ super characterLiteral ==> [ :token |
		SYMLASTLiteralCharacterValue new
			tokens: { token };
			position: token;
			value: (self parseCCharacter: token inputValue);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> commaExpression [
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
SysmelParser >> dictionaryElement [
	^ super dictionaryElement ==> [ :tokens |
		SYMLASTDictionaryKeyAndValue new
			tokens: tokens;
			position: tokens first;
			key: tokens first;
			value: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> dictionaryElementList [
	^ super dictionaryElementList ==> [ :tokens |
		(tokens first
			ifNil: [ #() ]
			ifNotNil: [ {tokens first} ]) ,
			(tokens second collect: #second thenSelect: #isNotNil)
	]
]

{ #category : #accessing }
SysmelParser >> dictionaryExpression [
	^ super dictionaryExpression ==> [ :tokens |
		SYMLASTDictionaryConstruction new
			position: tokens first;
			tokens: { tokens first . tokens last };
			associations: tokens third;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> dictionaryExpressionKey [
	^ super dictionaryExpressionKey ==> [ :tokens | tokens first ]
]

{ #category : #accessing }
SysmelParser >> dictionaryKeywordKey [
	^ super dictionaryKeywordKey ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButLast asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> expressionList [
	^ super expressionList ==> [ :list |
		({ list first } , (list second collect: #second)) select: #isNotNil
	]
]

{ #category : #accessing }
SysmelParser >> floatNumber [
	^ super floatNumber ==> [ :token | SYMLASTLiteralFloatValue new
			tokens: { token };
			position: token;
			value: (self parseFloatValue: token inputValue);
			yourself
			]
]

{ #category : #accessing }
SysmelParser >> identifierExpression [
	^ super identifierExpression ==> [ :token |
		SYMLASTIdentifierReference new
			position: token;
			tokens: { token };
			value: token inputValue asSymbol;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> implicitContextChainExpression [
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
SysmelParser >> innerLiteralArrayLiteral [
	^ super innerLiteralArrayLiteral ==> [ :tokens |
		SYMLASTLiteralArrayValue new
			tokens: { tokens first . tokens last  };
			position: tokens first;
			elements: tokens second asArray;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> integerNumber [
	^ super integerNumber ==> [ :token | SYMLASTLiteralIntegerValue new
			tokens: { token };
			position: token;
			value: (self parseIntegerValue: token inputValue);
			yourself
			]
]

{ #category : #accessing }
SysmelParser >> literalArray [
	^ super literalArray ==> [ :tokens |
		SYMLASTLiteralArrayValue new
			tokens: { tokens first . tokens last  };
			position: tokens first;
			elements: tokens second asArray;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> literalArrayBinaryOperator [
	^ super literalArrayBinaryOperator ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> literalArrayIdentifier [
	^ super literalArrayIdentifier ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> literalArrayKeyword [
	^ super literalArrayKeyword ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> lowPrecedenceExpression [
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
SysmelParser >> operate: left with: right do: operation [
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: operation inputValue asSymbol;
		receiver: left;
		arguments: {right};
		yourself

]

{ #category : #accessing }
SysmelParser >> parentExpression [
	^ super parentExpression ==> [ :tokens |
		tokens second ifNil: [
			SYMLASTCommaSeparatedList new
				position: tokens first;
				tokens: { tokens first . tokens last };
				expressions: #();
				yourself
		] ifNotNil: [ 
			SYMLASTParentExpression new
				position: tokens first;
				tokens: { tokens first . tokens last };
				expression: tokens second;
				yourself
		].
	]
]

{ #category : #parsing }
SysmelParser >> parse: aCollection [
	^ super parse: aCollection asMoebiusBandCollectionWithContext
]

{ #category : #accessing }
SysmelParser >> parseCCharacter: aString [
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

{ #category : #accessing }
SysmelParser >> parseCEscapeSequenceFrom: in into: out [
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
SysmelParser >> parseCString: aString [
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
SysmelParser >> parseFloatValue: aString [
	^ (aString first = $+ ifTrue: [ aString allButFirst ] ifFalse: [ aString ]) asNumber asFloat
]

{ #category : #accessing }
SysmelParser >> parseIntegerValue: aString [
	^ (aString first = $+ ifTrue: [ aString allButFirst ] ifFalse: [ aString ]) asNumber
]

{ #category : #accessing }
SysmelParser >> postfix: operation operate: operand [
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: ('postfix-' , operation inputValue) asSymbol;
		receiver: operand;
		arguments: #();
		yourself

]

{ #category : #accessing }
SysmelParser >> pragma [
	^ super pragma ==> [ :tokens |
		tokens second
			position: tokens first;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> pragmaChainKeywordMessage [
	^ super pragmaChainKeywordMessage ==> [ :components |
		SYMLASTPragma new
			position: components first first;
			selector: (ByteString streamContents: [:out |
				components do: [ :comp | out nextPutAll: comp first inputValue ]
			]) asSymbol;
			arguments: (components collect: #second);
			yourself

	]
]

{ #category : #accessing }
SysmelParser >> pragmaChainUnaryMessage [
	^ super pragmaChainUnaryMessage ==> [ :token |
		SYMLASTPragma new
			position: token;
			selector: token inputValue asSymbol;
			arguments: #();
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> prefix: operation operate: operand [
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: ('prefix-' , operation inputValue) asSymbol;
		receiver: operand;
		arguments: #();
		yourself

]

{ #category : #accessing }
SysmelParser >> quasiquoteExpression [
	^ super quasiquoteExpression ==> [ :tokens |
		SYMLASTQuasiQuote new
			tokens: { tokens first };
			position: tokens first;
			expression: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> quoteExpression [
	^ super quoteExpression ==> [ :tokens |
		SYMLASTQuote new
			tokens: { tokens first };
			position: tokens first;
			expression: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> spliceExpression [
	^ super unquoteExpression ==> [ :tokens |
		SYMLASTSplice new
			tokens: { tokens first };
			position: tokens first;
			expression: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> start [
	^ super start ==> [ :tokens |
		SYMLASTFile new
			headerComments: tokens first;
			expressions: tokens second;
			footerComments: tokens third;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> stringLiteral [
	^ super stringLiteral ==> [ :token |
		SYMLASTLiteralStringValue new
			tokens: { token };
			position: token;
			value: (self parseCString: token inputValue);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> symbolIdentifierLiteral [
	^ super symbolIdentifierLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> symbolKeywordLiteral [
	^ super symbolKeywordLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> symbolOperatorLiteral [
	^ super symbolOperatorLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> symbolStringLiteral [
	^ super symbolStringLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (self parseCString: token inputValue allButFirst) asSymbol;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> unaryExpression [
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
SysmelParser >> unaryExpressionSuffixCall [
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		SYMLASTFunctionApplication new
			position: tokens first;
			tokens: { tokens first . tokens last };
			arguments: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> unaryExpressionSuffixMessage [
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
SysmelParser >> unaryExpressionSuffixUnquote [
	^ super unaryExpressionSuffixUnquote ==> [ :unquote |
		SYMLASTMessageSend new
			position: unquote;
			tokens: unquote tokens;
			selector: unquote;
			arguments: #();
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> unarySuffixSubscript [
	^ super unarySuffixSubscript ==> [ :tokens |
		SYMLASTSubscriptExpression new
			position: tokens first;
			tokens: { tokens first . tokens last };
			index: tokens second;
			yourself
	]
]

{ #category : #accessing }
SysmelParser >> unquoteExpression [
	^ super unquoteExpression ==> [ :tokens |
		SYMLASTQuasiUnquote new
			tokens: { tokens first };
			position: tokens first;
			expression: tokens second;
			yourself
	]
]
