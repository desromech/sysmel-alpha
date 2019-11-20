Class {
	#name : #MbndAstEnumDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstEnumDeclarationNode >> accept: aVisitor [
	^ aVisitor visitEnumDeclarationNode: self
]

{ #category : #testing }
MbndAstEnumDeclarationNode >> isEnumDeclarationNode [
	^ true
]
