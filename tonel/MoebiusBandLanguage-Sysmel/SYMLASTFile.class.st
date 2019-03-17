Class {
	#name : #SYMLASTFile,
	#superclass : #SYMLASTNode,
	#instVars : [
		'headerComments',
		'footerComments',
		'expressions'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTFile >> buildMoebiusAST: builder [
	^ (builder sequence: (expressions collect: [:expr | expr buildMoebiusAST: builder] ))
		position: self;
		yourself
]

{ #category : #accessing }
SYMLASTFile >> children [
	^ expressions
]

{ #category : #accessing }
SYMLASTFile >> expressions [
	^ expressions
]

{ #category : #accessing }
SYMLASTFile >> expressions: anObject [
	expressions := anObject
]

{ #category : #accessing }
SYMLASTFile >> footerComments [
	^ footerComments
]

{ #category : #accessing }
SYMLASTFile >> footerComments: anObject [
	footerComments := anObject
]

{ #category : #accessing }
SYMLASTFile >> headerComments [
	^ headerComments
]

{ #category : #accessing }
SYMLASTFile >> headerComments: anObject [
	headerComments := anObject
]

{ #category : #printing }
SYMLASTFile >> printOn: aStream [
	aStream nextPutAll: 'file'
]
