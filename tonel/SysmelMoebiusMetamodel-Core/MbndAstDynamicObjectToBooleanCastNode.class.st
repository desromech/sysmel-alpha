Class {
	#name : #MbndAstDynamicObjectToBooleanCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDynamicObjectToBooleanCastNode >> accept: visitor [
	^ visitor visitDynamicObjectToBooleanCastNode: self
]

{ #category : #testing }
MbndAstDynamicObjectToBooleanCastNode >> isDynamicObjectToBooleanCastNode [
	^ true
]
