Class {
	#name : #SYMLASTBlockClosure,
	#superclass : #SYMLASTBlock,
	#instVars : [
		'signature'
	],
	#category : #'SysmelLanguage-AST'
}

{ #category : #converting }
SYMLASTBlockClosure >> buildArgumentDefinition: argumentNode with: builder [
	argumentNode isIdentifierReference ifTrue: [ 
		self halt.
	].

	argumentNode isMessageNode ifTrue: [
		argumentNode receiver ifNotNil: [ 
			self error: 'Argument specification cannot have a receiver.' at: argumentNode
		].
	
		(argumentNode selector endsWith: ':') ifFalse: [ 
			self error: 'Expected a closure argument specification with a valid name.' at: argumentNode
		].
	
		^ (builder argumentName: argumentNode selector allButLast asSymbol
			typeExpression: (argumentNode arguments first buildMoebiusAST: builder))
			position: argumentNode;
			yourself
	].

	self error: 'Expected a closure argument specification.' at: argumentNode
]

{ #category : #converting }
SYMLASTBlockClosure >> buildArgumentsDefinitions: argumentsNode with: builder [
	| argumentsList |
	argumentsNode isParentExpression ifTrue: [ ^ self buildArgumentsDefinitions: argumentsNode expression with: builder ].
	
	argumentsList := argumentsNode isCommaSeparatedList
		ifTrue: [ argumentsNode expressions ]
		ifFalse: [ { argumentsNode } ].
		
	^ argumentsList collect: [ :arg | self buildArgumentDefinition: arg with: builder ] 
]

{ #category : #converting }
SYMLASTBlockClosure >> buildMoebiusAST: builder [
	| body argumentsAndReturnType |
	argumentsAndReturnType := self buildSignatureWith: builder.
	
	body := (builder pragmas: (pragmas collect: [:pragma | pragma buildMoebiusAST: builder]) sequence: (expressions collect: [:expr | expr buildMoebiusAST: builder] ))
		position: self.
	^ (builder blockClosure: body arguments: argumentsAndReturnType first returnTypeExpression: argumentsAndReturnType second)
		position: self
]

{ #category : #converting }
SYMLASTBlockClosure >> buildSignatureWith: builder [
	| argumentDefinitions resultType |
	argumentDefinitions := nil.
	resultType := nil.
	
	signature isCommaSeparatedList ifTrue: [
		argumentDefinitions := self buildArgumentsDefinitions: signature with: builder.
	] ifFalse: [
		signature isMessageNode ifTrue: [
			signature selector == #=> ifTrue: [
				self assert: signature arguments size = 1.
				argumentDefinitions := self buildArgumentsDefinitions: signature receiver with: builder.
				resultType := signature arguments first buildMoebiusAST: builder.
			] ifFalse: [
				argumentDefinitions := self buildArgumentsDefinitions: signature with: builder.
			].
		] ifFalse: [ 
			argumentDefinitions := self buildArgumentsDefinitions: signature with: builder.
		]
	].

	^ { argumentDefinitions . resultType }
]

{ #category : #printing }
SYMLASTBlockClosure >> children [
	^ {#arguments -> signature} , super children
]

{ #category : #printing }
SYMLASTBlockClosure >> printOn: aStream [
	aStream nextPutAll: 'block-closure'
]

{ #category : #accessing }
SYMLASTBlockClosure >> signature [
	^ signature
]

{ #category : #accessing }
SYMLASTBlockClosure >> signature: anObject [
	signature := anObject
]
