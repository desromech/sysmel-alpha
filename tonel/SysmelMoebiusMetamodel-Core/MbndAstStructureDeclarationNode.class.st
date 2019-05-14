Class {
	#name : #MbndAstStructureDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstStructureDeclarationNode >> accept: aVisitor [
	^ aVisitor visitStructureDeclarationNode: self
]

{ #category : #testing }
MbndAstStructureDeclarationNode >> isStructureDeclarationNode [
	^ true
]
