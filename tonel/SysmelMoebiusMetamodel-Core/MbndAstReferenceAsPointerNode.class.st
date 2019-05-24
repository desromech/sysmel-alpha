Class {
	#name : #MbndAstReferenceAsPointerNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'reference'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReferenceAsPointerNode >> accept: aVisitor [
	^ aVisitor visitReferenceAsPointerNode: self
]

{ #category : #testing }
MbndAstReferenceAsPointerNode >> isReferenceAsPointerNode [
	^ true
]

{ #category : #accessing }
MbndAstReferenceAsPointerNode >> reference [
	^ reference
]

{ #category : #accessing }
MbndAstReferenceAsPointerNode >> reference: anObject [
	reference := anObject
]
