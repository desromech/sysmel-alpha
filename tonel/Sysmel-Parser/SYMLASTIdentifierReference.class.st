Class {
	#name : #SYMLASTIdentifierReference,
	#superclass : #SYMLASTNode,
	#instVars : [
		'value'
	],
	#category : #Sysmel-Parser-AST
}

{ #category : #converting }
SYMLASTIdentifierReference >> buildAPSG: builder [
	^ (builder identifier: value) position: self
]

{ #category : #printing }
SYMLASTIdentifierReference >> printOn: aStream [
	aStream nextPutAll: 'identifier  '; print: value
]

{ #category : #accessing }
SYMLASTIdentifierReference >> value [
	^ value
]

{ #category : #accessing }
SYMLASTIdentifierReference >> value: anObject [
	value := anObject
]
