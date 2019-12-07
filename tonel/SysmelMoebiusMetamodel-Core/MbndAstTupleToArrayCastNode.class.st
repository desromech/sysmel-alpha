Class {
	#name : #MbndAstTupleToArrayCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTupleToArrayCastNode >> accept: visitor [
	^ visitor visitTupleToArrayCastNode: self
]

{ #category : #testing }
MbndAstTupleToArrayCastNode >> isTupleToArrayCastNode [
	^ true
]
