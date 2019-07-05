Class {
	#name : #MbndAstConvertToASTNodeCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstConvertToASTNodeCastNode >> accept: aVisitor [
	^ aVisitor visitConvertToASTNodeCastNode: self
]

{ #category : #testing }
MbndAstConvertToASTNodeCastNode >> isConvertToASTNodeCastNode [
	^ true
]
