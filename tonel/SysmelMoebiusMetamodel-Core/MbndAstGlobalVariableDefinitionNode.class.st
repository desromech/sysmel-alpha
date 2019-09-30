Class {
	#name : #MbndAstGlobalVariableDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGlobalVariableDefinitionNode >> accept: aVisitor [
	^ aVisitor visitGlobalVariableDefinitionNode: self
]

{ #category : #testing }
MbndAstGlobalVariableDefinitionNode >> isGlobalVariableDefinitionNode [
	^ true
]
