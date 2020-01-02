Class {
	#name : #MbndAstInterfaceDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstInterfaceDefinitionNode >> accept: aVisitor [
	^ aVisitor visitInterfaceDefinitionNode: self
]

{ #category : #testing }
MbndAstInterfaceDefinitionNode >> isInterfaceDefinitionNode [
	^ true
]
