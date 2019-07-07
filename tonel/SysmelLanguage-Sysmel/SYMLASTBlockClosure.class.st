Class {
	#name : #SYMLASTBlockClosure,
	#superclass : #SYMLASTBlock,
	#instVars : [
		'signature'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTBlockClosure >> buildMoebiusAST: builder [
	| body arguments returnType |
	arguments := signature arguments collect: [ :arg | arg buildMoebiusAST: builder ].
	returnType := signature returnType ifNotNil: [ :node | node buildMoebiusAST: builder ].

	body := (builder pragmas: (pragmas collect: [:pragma | pragma buildMoebiusAST: builder]) sequence: (expressions collect: [:expr | expr buildMoebiusAST: builder] ))
		position: self.

	^ (builder blockClosureWithArguments: arguments returnType: returnType body: body)
		position: self
]

{ #category : #printing }
SYMLASTBlockClosure >> children [
	^ {signature} , super children
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
