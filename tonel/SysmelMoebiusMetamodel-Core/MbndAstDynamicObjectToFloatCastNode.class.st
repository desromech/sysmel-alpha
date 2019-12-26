Class {
	#name : #MbndAstDynamicObjectToFloatCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDynamicObjectToFloatCastNode >> accept: visitor [
	^ visitor visitDynamicObjectToFloatCastNode: self
]

{ #category : #testing }
MbndAstDynamicObjectToFloatCastNode >> isDynamicObjectToFloatCastNode [
	^ true
]
