Class {
	#name : #MbndAstVariableReference,
	#superclass : #MbndAstSymbolReference,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVariableReference >> accept: aVisitor [
	^ aVisitor visitVariableReferenceNode: self
]

{ #category : #testing }
MbndAstVariableReference >> isVariableReferenceNode [
	^ true
]
