Class {
	#name : #MbndAstSymbolReference,
	#superclass : #MbndAstNode,
	#instVars : [
		'binding'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstSymbolReference >> binding [
	^ binding
]

{ #category : #accessing }
MbndAstSymbolReference >> binding: anObject [
	binding := anObject.
	type := binding type.
]

{ #category : #testing }
MbndAstSymbolReference >> isBoundIdentifierReferenceNode [
	^ true
]
