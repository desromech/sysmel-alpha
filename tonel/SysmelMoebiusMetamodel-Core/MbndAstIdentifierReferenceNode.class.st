Class {
	#name : #MbndAstIdentifierReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'symbol'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIdentifierReferenceNode >> accept: aVisitor [
	^ aVisitor visitIdentifierReferenceNode: self
]

{ #category : #testing }
MbndAstIdentifierReferenceNode >> isIdentifierReferenceNode [
	^ true
]

{ #category : #parsing }
MbndAstIdentifierReferenceNode >> parseAsArgumentDefinition [
	^ MbndAstArgumentDefinitionNode new
		position: self;
		name: symbol;
		yourself
]

{ #category : #parsing }
MbndAstIdentifierReferenceNode >> parseAsFunctionArgumentsPrototype [
	^ { self parseAsArgumentDefinition }
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol [
	^ symbol
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol: anObject [
	symbol := anObject
]
