Class {
	#name : #MbndAstTraitDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTraitDefinitionNode >> accept: aVisitor [
	^ aVisitor visitTraitDefinitionNode: self
]

{ #category : #testing }
MbndAstTraitDefinitionNode >> isTraitDefinitionNode [
	^ true
]
