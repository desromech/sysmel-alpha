Class {
	#name : #SYMLASTAssignment,
	#superclass : #SYMLASTNode,
	#instVars : [
		'reference',
		'value'
	],
	#category : #'SysmelLanguage-AST'
}

{ #category : #converting }
SYMLASTAssignment >> buildMoebiusAST: builder [
	^ (builder unexpandedSend: #assignValue:
		to: (reference buildMoebiusAST: builder)
		withArguments: {value buildMoebiusAST: builder})
		position: self;
		yourself

]

{ #category : #accessing }
SYMLASTAssignment >> children [
	^ { reference . value }
]

{ #category : #printing }
SYMLASTAssignment >> printOn: aStream [
	aStream nextPutAll: 'assignment'
]

{ #category : #accessing }
SYMLASTAssignment >> reference [
	^ reference
]

{ #category : #accessing }
SYMLASTAssignment >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
SYMLASTAssignment >> value [
	^ value
]

{ #category : #accessing }
SYMLASTAssignment >> value: anObject [
	value := anObject
]
