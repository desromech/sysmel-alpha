Class {
	#name : #MbndAstTraitDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTraitDeclarationNode >> accept: visitor [
	^ visitor visitTraitDeclarationNode: self
]

{ #category : #testing }
MbndAstTraitDeclarationNode >> isTraitDeclarationNode [
	^ true
]
