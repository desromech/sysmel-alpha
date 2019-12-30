Class {
	#name : #MbndAstCharacterToDynamicObjectCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCharacterToDynamicObjectCastNode >> accept: visitor [
	^ visitor visitCharacterToDynamicObjectCastNode: self
]

{ #category : #testing }
MbndAstCharacterToDynamicObjectCastNode >> isCharacterToDynamicObjectCastNode [
	^ true
]
