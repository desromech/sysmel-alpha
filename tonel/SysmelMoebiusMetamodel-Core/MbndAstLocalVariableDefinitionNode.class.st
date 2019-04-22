Class {
	#name : #MbndAstLocalVariableDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLocalVariableDefinitionNode >> accept: aVisitor [
	^ aVisitor visitLocalVariableDefinitionNode: self
]

{ #category : #testing }
MbndAstLocalVariableDefinitionNode >> isLocalVariableDefinitionNode [
	^ true
]
