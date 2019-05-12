Class {
	#name : #MbndAstSignExtensionCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSignExtensionCastNode >> accept: aVisitor [
	^ aVisitor visitSignExtensionCastNode: self
]

{ #category : #testing }
MbndAstSignExtensionCastNode >> isSignExtensionCastNode [
	^ true
]
