Class {
	#name : #SYMLSyntaxHighlighter,
	#superclass : #SYMLGrammar,
	#instVars : [
		'commands'
	],
	#classVars : [
		'Keywords'
	],
	#category : #Sysmel-Phanide
}

{ #category : #'as yet unclassified' }
SYMLSyntaxHighlighter class >> ignoredNames [
	^ super ignoredNames, #(commands)
]

{ #category : #initialization }
SYMLSyntaxHighlighter class >> initialize [
	super initialize.
	
	Keywords := Set newFrom: #(
		#true #false #nil
		thisContext self super
		
		let namespace struct function template method field
	).
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> chainKeywordMessage [
	^ super chainKeywordMessage ==> [ :tokens |
		tokens do: [ :pair |
			self commands add: (PhanideHighlightCommandStyle method token: pair first).
		].
		tokens
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> chainUnaryMessage [
	^ super chainUnaryMessage ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle method token: token).
		token
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> commands [ 
	^ commands ifNil: [ commands := OrderedCollection new ]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> identifierExpression [
	^ super identifierExpression ==> [ :token |
		(Keywords includes: token inputValue) ifTrue: [
			self commands add: (PhanideHighlightCommandStyle keyword token: token).
		] ifFalse: [ 
			self commands add: (PhanideHighlightCommandStyle identifier token: token).
		].
		token
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> innerLiteralArrayLiteral [
	^ super innerLiteralArrayLiteral ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> keyword: aKeyword [
	^ (super keyword: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle keyword token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> languageScapeExpression [
	^ super languageScapeExpression ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle keyword token: tokens first);
			add: (PhanideHighlightCommandStyle keyword token: tokens second).
		SYMLScapedLanguageCompiler tryToStyle: tokens third language: tokens second inputValue into: commands.
		tokens
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> literalArray [
	^ super literalArray ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> literalArrayBinaryOperator [
	^ super literalArrayBinaryOperator ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> literalArrayIdentifier [
	^ super literalArrayIdentifier ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> literalArrayKeyword [
	^ super literalArrayKeyword ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> multiLineComment [
	^ super multiLineComment token ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle multiLineComment token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> number [
	^ super number ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle number token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> operator: aKeyword [
	^ (super operator: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle operator token: token).
		token
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> pragma [
	^ super pragma ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle pragma token: tokens first);
			add: (PhanideHighlightCommandStyle pragma token: tokens last)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> pragmaChainKeywordMessage [
	^ super pragmaChainKeywordMessage ==> [ :tokens |
		tokens do: [ :pair |
			self commands
				add: (PhanideHighlightCommandStyle pragma token: pair first)
		]
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> pragmaChainUnaryMessage [
	^ super pragmaChainUnaryMessage ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle pragma token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> singleLineComment [
	^ super singleLineComment token ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle singleLineComment token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> symbolLiteral [
	^ super symbolLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> unaryExpressionSuffixCall [
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle callBracket token: tokens first);
			add: (PhanideHighlightCommandStyle callBracket token: tokens last)
	]
]

{ #category : #accessing }
SYMLSyntaxHighlighter >> unaryExpressionSuffixMessage [
	^ super unaryExpressionSuffixMessage ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle method token: token).
		token
	]
]
