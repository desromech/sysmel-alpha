Class {
	#name : #MbndAstFloatToDynamicObjectCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFloatToDynamicObjectCastNode >> accept: visitor [
	^ visitor visitFloatToDynamicObjectCastNode: self
]

{ #category : #testing }
MbndAstFloatToDynamicObjectCastNode >> isFloatingPointToDynamicObjectCastNode [
	^ true
]
