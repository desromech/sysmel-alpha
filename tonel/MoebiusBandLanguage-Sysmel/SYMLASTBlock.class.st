Class {
	#name : #SYMLASTBlock,
	#superclass : #SYMLASTNode,
	#instVars : [
		'pragmas',
		'expressions'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTBlock >> buildMoebiusAST: builder [
	^ (builder pragmas: (pragmas collect: [:pragma | pragma buildMoebiusAST: builder]) sequence: (expressions collect: [:expr | expr buildMoebiusAST: builder] ))
		position: self;
		lexicalScoped
]

{ #category : #accessing }
SYMLASTBlock >> children [
	^ { #pragmas -> pragmas . #expressions -> expressions }
]

{ #category : #accessing }
SYMLASTBlock >> expressions [
	^ expressions
]

{ #category : #accessing }
SYMLASTBlock >> expressions: anObject [
	expressions := anObject
]

{ #category : #accessing }
SYMLASTBlock >> pragmas [
	^ pragmas
]

{ #category : #accessing }
SYMLASTBlock >> pragmas: anObject [
	pragmas := anObject
]

{ #category : #printing }
SYMLASTBlock >> printOn: aStream [
	aStream nextPutAll: 'block'
]
