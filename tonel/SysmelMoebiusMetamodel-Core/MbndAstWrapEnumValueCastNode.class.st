Class {
	#name : #MbndAstWrapEnumValueCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstWrapEnumValueCastNode >> accept: aVisitor [
	^ aVisitor visitWrapEnumValueCastNode: self
]

{ #category : #testing }
MbndAstWrapEnumValueCastNode >> isWrapEnumValueNode [
	^ true
]
