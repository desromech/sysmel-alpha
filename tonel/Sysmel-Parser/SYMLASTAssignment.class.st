Class {
	#name : #SYMLASTAssignment,
	#superclass : #SYMLASTNode,
	#instVars : [
		'reference',
		'value'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTAssignment >> buildAPSG: builder [
	^ (builder send: #assignValue:
		to: (reference buildAPSG: builder)
		withArguments: {value buildAPSG: builder})
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
