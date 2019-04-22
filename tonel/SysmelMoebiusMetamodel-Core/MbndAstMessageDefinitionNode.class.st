Class {
	#name : #MbndAstMessageDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageDefinitionNode >> accept: aVisitor [
	^ aVisitor visitMessageDefinitionNode: self
]

{ #category : #testing }
MbndAstMessageDefinitionNode >> isMessageDefinitionNode [
	^ true
]
