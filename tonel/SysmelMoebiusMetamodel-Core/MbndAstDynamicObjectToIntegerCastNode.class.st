Class {
	#name : #MbndAstDynamicObjectToIntegerCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDynamicObjectToIntegerCastNode >> accept: visitor [
	^ visitor visitDynamicObjectToIntegerCastNode: self
]

{ #category : #testing }
MbndAstDynamicObjectToIntegerCastNode >> isDynamicObjectToIntegerCastNode [
	^ true
]
