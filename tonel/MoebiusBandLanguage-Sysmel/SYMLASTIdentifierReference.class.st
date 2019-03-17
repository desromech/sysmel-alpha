Class {
	#name : #SYMLASTIdentifierReference,
	#superclass : #SYMLASTNode,
	#instVars : [
		'value'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTIdentifierReference >> buildMoebiusAST: builder [
	^ (builder identifier: value) position: self
]

{ #category : #testing }
SYMLASTIdentifierReference >> isIdentifierReference [
	^ true
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
