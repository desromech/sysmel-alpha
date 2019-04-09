Class {
	#name : #MbndAstSymbolDefinition,
	#superclass : #MbndAstNode,
	#instVars : [
		'name'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstSymbolDefinition >> name [
	^ name
]

{ #category : #accessing }
MbndAstSymbolDefinition >> name: anObject [
	name := anObject
]
