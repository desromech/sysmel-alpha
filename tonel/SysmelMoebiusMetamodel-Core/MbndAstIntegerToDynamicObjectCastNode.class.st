Class {
	#name : #MbndAstIntegerToDynamicObjectCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIntegerToDynamicObjectCastNode >> accept: visitor [
	^ visitor visitIntegerToDynamicObjectCastNode: self
]

{ #category : #testing }
MbndAstIntegerToDynamicObjectCastNode >> isIntegerToDynamicObjectCastNode [
	^ true
]
