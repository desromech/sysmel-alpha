Class {
	#name : #SYMLASTBlock,
	#superclass : #SYMLASTNode,
	#instVars : [
		'pragmas',
		'expressions'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTBlock >> buildAPSG: builder [
	^ (builder sequence: (expressions collect: [:expr | expr buildAPSG: builder] ))
		position: self;
		quoted
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
