Class {
	#name : #MbndAstAssignmentNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'reference',
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstAssignmentNode >> accept: aVisitor [
	^ aVisitor visitAssignmentNode: self
]

{ #category : #testing }
MbndAstAssignmentNode >> isAssignmentNode [
	^ true
]

{ #category : #accessing }
MbndAstAssignmentNode >> reference [
	^ reference
]

{ #category : #accessing }
MbndAstAssignmentNode >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
MbndAstAssignmentNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstAssignmentNode >> value: anObject [
	value := anObject
]
