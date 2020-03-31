Class {
	#name : #SysmelSyntaxHighlighter,
	#superclass : #SysmelAbstractASTNodeVisitor,
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
		#true #false #nil #void
		thisContext self super
		
		let namespace struct union class gcclass enum function template macro message method field
		public private static virtual abstract override compileTimeConstant global
	).
]

{ #category : #parsing }
SysmelSyntaxHighlighter >> addComment: comment [
	self commands add: (PhanideHighlightCommandStyle multiLineComment
		start: comment first;
		stop: comment second;
		yourself)
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

{ #category : #parsing }
SysmelSyntaxHighlighter >> parse: aText [
	| ast |
	[
		ast := SysmelParser parse: aText asString.
	] on: SmaCCParserError do: [ :e |
		self commands add: (PhanideHighlightCommandStyle syntaxError
			start:	 e tag position;
			stop: aText size + 1;
			yourself).
		^ self.
	].

	ast comments do: [ :each | self addComment: each ].

	self visitNode: ast
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

{ #category : #initialization }
SysmelSyntaxHighlighter >> setToken: token style: styleName [
	self commands add: ((PhanideHighlightCommandStyle style: styleName)
		start: token startPosition;
		stop: token stopPosition;
		yourself)
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

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitBinaryExpression: binaryExpression [
	self visitNode: binaryExpression left.
	self visitNode: binaryExpression right.
	self setToken: binaryExpression operation style: #operator
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitBlockClosureArgument: blockArgument [
	blockArgument type ifNotNil: [ 
		self visitNode: blockArgument type.
	].

	self setToken: blockArgument colonToken style: #bracket.
	self visitNode: blockArgument name.

]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitBlockClosureSignature: node [
	node returnType ifNotNil: [ :rt | self visitNode: rt ].
	node colonColon ifNotNil: [ 
		self setToken: node colonColon style: #bracket
	].

	self setToken: node orToken style: #bracket

]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitBlockExpression: blockExpression [
	blockExpression blockClosureSignature ifNotNil: [ :n | self visitNode: n].
	self visitNodes: blockExpression pragmas.
	self visitNode: blockExpression expressions.
	self setToken: blockExpression lbracket style: #bracket.
	self setToken: blockExpression rbracket style: #bracket.

]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitCallExpression: node [
	self visitNode: node function.
	self visitNode: node arguments.
	self setToken: node lparent style: #callBracket.
	self setToken: node rparent style: #callBracket.
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitExpressionList: node [
	self visitNodes: node expressions
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitFile: node [
	^ self visitNode: node expressionList
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitIdentifierReference: identifier [
	| symbol |
	symbol := identifier symbol value.
	(Keywords includes: symbol) ifTrue: [
		self setToken: identifier style: #keyword
	] ifFalse: [ 
		self setToken: identifier style: #identifier
	]
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitKeywordMessage: node [
	self visitNodes: node arguments.
	node keywords do: [ :each |
		self setToken: each style: #method
	].
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitLiteralCharacter: literal [
	self setToken: literal style: #character
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitLiteralFloat: literal [
	self setToken: literal style: #number
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitLiteralInteger: literal [
	self setToken: literal style: #number
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitLiteralString: literal [
	self setToken: literal style: #string
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitLiteralSymbol: literal [
	self setToken: literal style: #symbol
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitMessageChain: node [
	node receiver ifNotNil: [ :r | self visitNode: r ].
	node firstMessage ifNotNil: [ :fm | self visitNode: fm ].
	self visitNodes: node chainedMessages.
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitNode: ast [
	^ ast acceptVisitor: self
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitNodes: nodes [
	nodes do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitParenthesesExpression: expression [
	self visitNode: expression expression.
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitPragma: pragma [
	self visitNode: pragma message.
	self setToken: pragma lessThan style: #pragma.
	self setToken: pragma greaterThan style: #pragma.
]

{ #category : #visiting }
SysmelSyntaxHighlighter >> visitUnaryMessage: unaryMessage [
	unaryMessage receiver ifNotNil: [ 
		self visitNode: unaryMessage receiver.
	].
	self setToken: unaryMessage selector style: #method
]
