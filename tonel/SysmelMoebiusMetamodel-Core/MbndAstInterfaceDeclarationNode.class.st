Class {
	#name : #MbndAstInterfaceDeclarationNode,
	#superclass : #MbndAstAbstractTypeDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstInterfaceDeclarationNode >> accept: visitor [
	^ visitor visitInterfaceDeclarationNode: self
]

{ #category : #testing }
MbndAstInterfaceDeclarationNode >> isInterfaceDeclarationNode [
	^ true
]
