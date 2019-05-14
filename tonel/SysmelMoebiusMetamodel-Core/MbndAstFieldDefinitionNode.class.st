Class {
	#name : #MbndAstFieldDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFieldDefinitionNode >> accept: aVisitor [
	^ aVisitor visitFieldDefinitionNode: self
]

{ #category : #testing }
MbndAstFieldDefinitionNode >> isFieldDefinitionNode [
	^ true
]
