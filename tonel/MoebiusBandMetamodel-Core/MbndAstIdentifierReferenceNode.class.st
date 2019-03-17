Class {
	#name : #MbndAstIdentifierReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'symbol'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstIdentifierReferenceNode >> isIdentifierReferenceNode [
	^ true
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol [
	^ symbol
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol: anObject [
	symbol := anObject
]
