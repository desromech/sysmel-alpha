Class {
	#name : #MbndAstGetFieldReferenceNode,
	#superclass : #MbndAstAbstractFieldAccessNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGetFieldReferenceNode >> accept: aVisitor [
	^ aVisitor visitGetFieldReferenceNode: self
]

{ #category : #testing }
MbndAstGetFieldReferenceNode >> isGetFieldReferenceNode [
	^ true
]
