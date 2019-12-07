Class {
	#name : #MbndAstMethodReference,
	#superclass : #MbndAstSymbolReference,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMethodReference >> accept: aVisitor [
	^ aVisitor visitMethodReferenceNode: self
]

{ #category : #'as yet unclassified' }
MbndAstMethodReference >> calledFunctionBinding [
	^ binding
]

{ #category : #testing }
MbndAstMethodReference >> isMethodReferenceNode [
	^ true
]
