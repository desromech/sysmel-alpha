Class {
	#name : #MbndAstGetFieldValueNode,
	#superclass : #MbndAstAbstractFieldAccessNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGetFieldValueNode >> accept: aVisitor [
	^ aVisitor visitGetFieldValueNode: self
]

{ #category : #testing }
MbndAstGetFieldValueNode >> isGetFieldValueNode [
	^ true
]
