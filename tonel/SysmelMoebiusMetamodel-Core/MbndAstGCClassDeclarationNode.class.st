Class {
	#name : #MbndAstGCClassDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGCClassDeclarationNode >> accept: aVisitor [
	^ aVisitor visitGCClassDeclarationNode: self
]

{ #category : #testing }
MbndAstGCClassDeclarationNode >> isGCClassDeclarationNode [
	^ true
]
