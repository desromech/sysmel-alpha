Class {
	#name : #MbndAstConvertFromCompilerObjectCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstConvertFromCompilerObjectCastNode >> accept: aVisitor [
	^ aVisitor visitConvertFromCompilerObjectCastNode: self
]

{ #category : #testing }
MbndAstConvertFromCompilerObjectCastNode >> isConvertFromCompilerObjectCastNode [
	^ true
]
