Class {
	#name : #MbndAstUnwrapEnumValueCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstUnwrapEnumValueCastNode >> accept: aVisitor [
	^ aVisitor visitUnwrapEnumValueCastNode: self
]

{ #category : #testing }
MbndAstUnwrapEnumValueCastNode >> isUnwrapEnumValueNode [
	^ true
]
