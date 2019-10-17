Class {
	#name : #MbndAstGlobalVariableDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
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
