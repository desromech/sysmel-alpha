Class {
	#name : #SysmelSyntaxHighlighter,
	#superclass : #SysmelGrammar,
	#instVars : [
		'commands'
	],
	#classVars : [
		'Keywords'
	],
	#category : #'SysmelLanguage-SysmelPhanide'
}

{ #category : #'as yet unclassified' }
SysmelSyntaxHighlighter class >> ignoredNames [
	^ super ignoredNames, #(commands)
]

{ #category : #initialization }
SysmelSyntaxHighlighter class >> initialize [
	super initialize.
	
	"In Sysmel we do not have keywords. We fake them here."
	Keywords := Set newFrom: #(
		#true #false #nil
		thisContext self super
		
		let namespace struct union class gcclass enum function template macro message method field
		public private static virtual abstract override compileTimeConstant
	).
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> blockClosureArgument [
	^ super blockClosureArgument ==> [ :tokens |
		self commands add: (PhanideHighlightCommandStyle identifier token: tokens third).
		tokens
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> chainKeywordMessage [
	^ super chainKeywordMessage ==> [ :tokens |
		tokens do: [ :pair |
			self commands add: (PhanideHighlightCommandStyle method token: pair first).
		].
		tokens
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> chainUnaryMessage [
	^ super chainUnaryMessage ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle method token: token).
		token
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> commands [ 
	^ commands ifNil: [ commands := OrderedCollection new ]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> identifierExpression [
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
SysmelSyntaxHighlighter >> innerLiteralArrayLiteral [
	^ super innerLiteralArrayLiteral ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> literalArray [
	^ super literalArray ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> literalArrayBinaryOperator [
	^ super literalArrayBinaryOperator ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> literalArrayIdentifier [
	^ super literalArrayIdentifier ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> literalArrayKeyword [
	^ super literalArrayKeyword ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> multiLineComment [
	^ super multiLineComment ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle multiLineComment token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> number [
	^ super number ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle number token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> operator: aKeyword [
	^ (super operator: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle operator token: token).
		token
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> pragma [
	^ super pragma ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle pragma token: tokens first);
			add: (PhanideHighlightCommandStyle pragma token: tokens last)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> pragmaChainKeywordMessage [
	^ super pragmaChainKeywordMessage ==> [ :tokens |
		tokens do: [ :pair |
			self commands
				add: (PhanideHighlightCommandStyle pragma token: pair first)
		]
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> pragmaChainUnaryMessage [
	^ super pragmaChainUnaryMessage ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle pragma token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> singleLineComment [
	^ super singleLineComment ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle singleLineComment token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> stringLiteral [
	^ super stringLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> symbolLiteral [
	^ super symbolLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> unaryExpressionSuffixCall [
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle callBracket token: tokens first);
			add: (PhanideHighlightCommandStyle callBracket token: tokens last)
	]
]

{ #category : #accessing }
SysmelSyntaxHighlighter >> unaryExpressionSuffixMessage [
	^ super unaryExpressionSuffixMessage ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle method token: token).
		token
	]
]
