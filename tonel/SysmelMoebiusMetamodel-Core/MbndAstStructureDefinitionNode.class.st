Class {
	#name : #MbndAstStructureDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstStructureDefinitionNode >> accept: aVisitor [
	^ aVisitor visitStructureDefinitionNode: self
]

{ #category : #testing }
MbndAstStructureDefinitionNode >> isStructureDefinitionNode [
	^ true
]
