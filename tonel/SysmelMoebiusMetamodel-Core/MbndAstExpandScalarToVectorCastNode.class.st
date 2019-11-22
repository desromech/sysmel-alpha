Class {
	#name : #MbndAstExpandScalarToVectorCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstExpandScalarToVectorCastNode >> accept: visitor [
	^ visitor visitExpandScalarToVectorCastNode: self
]

{ #category : #testing }
MbndAstExpandScalarToVectorCastNode >> isExpandScalarToVectorCastNode [
	^ true
]
