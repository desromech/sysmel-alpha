Class {
	#name : #MbndAstZeroExtensionCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstZeroExtensionCastNode >> accept: aVisitor [
	^ aVisitor visitZeroExtensionCastNode: self
]

{ #category : #testing }
MbndAstZeroExtensionCastNode >> isZeroExtensionCastNode [
	^ true
]
