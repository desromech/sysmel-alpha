Class {
	#name : #MbndAstVAListEndExpressionNode,
	#superclass : #MbndAstVAListExpressionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVAListEndExpressionNode >> accept: visitor [
	^ visitor vistVAListEndExpressionNode: self
]

{ #category : #testing }
MbndAstVAListEndExpressionNode >> isVAListEndExpressionNode [
	^ true
]
