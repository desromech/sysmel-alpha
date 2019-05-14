Class {
	#name : #MbndAstUnionDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstUnionDeclarationNode >> accept: aVisitor [
	^ aVisitor visitUnionDeclarationNode: self
]

{ #category : #testing }
MbndAstUnionDeclarationNode >> isUnionDeclarationNode [
	^ true
]
