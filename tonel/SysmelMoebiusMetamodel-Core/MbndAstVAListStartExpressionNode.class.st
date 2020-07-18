Class {
	#name : #MbndAstVAListStartExpressionNode,
	#superclass : #MbndAstVAListExpressionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVAListStartExpressionNode >> accept: visitor [
	^ visitor vistVAListStartExpressionNode: self
]

{ #category : #testing }
MbndAstVAListStartExpressionNode >> isVAListStartExpressionNode [
	^ true
]
