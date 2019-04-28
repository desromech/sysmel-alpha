Class {
	#name : #MbndAstMethodReference,
	#superclass : #MbndAstSymbolReference,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMethodReference >> accept: aVisitor [
	^ aVisitor visitMethodReferenceNode: self
]

{ #category : #testing }
MbndAstMethodReference >> isMethodReferenceNode [
	^ true
]
