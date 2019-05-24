Class {
	#name : #MbndAstPointerAsReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'pointer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPointerAsReferenceNode >> accept: aVisitor [
	^ aVisitor visitPointerAsReferenceNode: self
]

{ #category : #testing }
MbndAstPointerAsReferenceNode >> isPointerAsReferenceNode [
	^ true
]

{ #category : #accessing }
MbndAstPointerAsReferenceNode >> pointer [
	^ pointer
]

{ #category : #accessing }
MbndAstPointerAsReferenceNode >> pointer: anObject [
	pointer := anObject
]
