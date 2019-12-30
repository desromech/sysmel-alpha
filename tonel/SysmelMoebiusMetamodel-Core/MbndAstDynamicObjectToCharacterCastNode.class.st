Class {
	#name : #MbndAstDynamicObjectToCharacterCastNode,
	#superclass : #MbndAstDynamicObjectCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDynamicObjectToCharacterCastNode >> accept: visitor [
	^ visitor visitDynamicObjectToCharacterCastNode: self
]

{ #category : #testing }
MbndAstDynamicObjectToCharacterCastNode >> isDynamicObjectToCharacterCastNode [
	^ true
]
