Class {
	#name : #MbndAstReferenceLoadNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'reference'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReferenceLoadNode >> accept: aVisitor [
	^ aVisitor visitReferenceLoadNode: self
]

{ #category : #testing }
MbndAstReferenceLoadNode >> isReferenceLoadNode [
	^ true
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> reference [
	^ reference
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> reference: anObject [
	reference := anObject
]
