Class {
	#name : #MbndAstClassDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstClassDeclarationNode >> accept: aVisitor [
	^ aVisitor visitClassDeclarationNode: self
]

{ #category : #testing }
MbndAstClassDeclarationNode >> isClassDeclarationNode [
	^ true
]
