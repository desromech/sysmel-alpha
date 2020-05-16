Class {
	#name : #MbndAstArraySliceDecorationChangeCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstArraySliceDecorationChangeCastNode >> accept: visitor [
	^ visitor visitArraySliceDecorationChangeCastNode: self
]

{ #category : #visiting }
MbndAstArraySliceDecorationChangeCastNode >> isArraySliceDecorationChangeCastNode [
	^ true
]
