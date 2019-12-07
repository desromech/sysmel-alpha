Class {
	#name : #MbndAstArrayConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'elementType',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstArrayConstructionNode >> accept: visitor [
	^ visitor visitArrayConstructionNode: self
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elements: anObject [
	elements := anObject
]

{ #category : #testing }
MbndAstArrayConstructionNode >> isArrayConstructionNode [
	^ true
]
