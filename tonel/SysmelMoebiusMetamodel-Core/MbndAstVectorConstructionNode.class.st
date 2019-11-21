Class {
	#name : #MbndAstVectorConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'vectorType',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstVectorConstructionNode >> accept: visitor [
	^ visitor visitVectorConstructionNode: self
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> elements: anObject [
	elements := anObject
]

{ #category : #testing }
MbndAstVectorConstructionNode >> isVectorConstructionNode [
	^ true
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> vectorType [
	^ vectorType
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> vectorType: anObject [
	vectorType := anObject
]
