Class {
	#name : #SYMLASTCommaSeparatedList,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expressions'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTCommaSeparatedList >> asList [
	^ self
]

{ #category : #converting }
SYMLASTCommaSeparatedList >> buildMoebiusAST: builder [
	^ (builder tuple: (expressions collect: [:expr | expr buildMoebiusAST: builder] ))
		position: self;
		yourself
]

{ #category : #accessing }
SYMLASTCommaSeparatedList >> children [
	^ expressions
]

{ #category : #enumerating }
SYMLASTCommaSeparatedList >> collect: aBlock [
	^ expressions collect: aBlock
]

{ #category : #enumerating }
SYMLASTCommaSeparatedList >> do: aBlock [
	^ expressions do: aBlock
]

{ #category : #accessing }
SYMLASTCommaSeparatedList >> expressions [
	^ expressions
]

{ #category : #accessing }
SYMLASTCommaSeparatedList >> expressions: anObject [
	expressions := anObject
]

{ #category : #testing }
SYMLASTCommaSeparatedList >> isCommaSeparatedList [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLASTCommaSeparatedList >> isEmpty [
	^ expressions isEmpty
]

{ #category : #printing }
SYMLASTCommaSeparatedList >> printOn: aStream [
	aStream nextPutAll: 'commaSequence'
]
