Class {
	#name : #MbndAstTupleNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstTupleNode >> accept: aVisitor [
	^ aVisitor visitTupleNode: self
]

{ #category : #accessing }
MbndAstTupleNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstTupleNode >> elements: anObject [
	elements := anObject
]

{ #category : #initialization }
MbndAstTupleNode >> initialize [
	super initialize.
	elements := #().
]

{ #category : #'as yet unclassified' }
MbndAstTupleNode >> isTupleNode [
	^ true
]

{ #category : #parsing }
MbndAstTupleNode >> parseAsFunctionArgumentsPrototype [
	^ elements collect: [:each | each parseAsArgumentDefinition]
]
