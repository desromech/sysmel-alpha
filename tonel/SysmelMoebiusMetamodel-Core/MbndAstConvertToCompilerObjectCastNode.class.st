Class {
	#name : #MbndAstConvertToCompilerObjectCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstConvertToCompilerObjectCastNode >> accept: aVisitor [
	^ aVisitor visitConvertToCompilerObjectCastNode: self
]

{ #category : #testing }
MbndAstConvertToCompilerObjectCastNode >> isConvertToCompilerObjectCastNode [
	^ true
]
