Class {
	#name : #MbndAstDecorationChangeTypeCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstDecorationChangeTypeCastNode >> accept: aVisitor [
	^ aVisitor visitDecorationChangeTypeCastNode: self
]

{ #category : #testing }
MbndAstDecorationChangeTypeCastNode >> isDecorationChangeTypeCastNode [
	^ true
]
