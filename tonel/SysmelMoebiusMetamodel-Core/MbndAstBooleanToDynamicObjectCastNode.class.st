Class {
	#name : #MbndAstBooleanToDynamicObjectCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBooleanToDynamicObjectCastNode >> accept: visitor [
	^ visitor visitBooleanToDynamicObjectCastNode: self
]

{ #category : #testing }
MbndAstBooleanToDynamicObjectCastNode >> isBooleanToDynamicObjectCastNode [
	^ true
]
