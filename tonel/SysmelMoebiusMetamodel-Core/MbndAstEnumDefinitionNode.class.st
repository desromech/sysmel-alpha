Class {
	#name : #MbndAstEnumDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#instVars : [
		'valueType',
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstEnumDefinitionNode >> accept: aVisitor [
	^ aVisitor visitEnumDefinitionNode: self
]

{ #category : #testing }
MbndAstEnumDefinitionNode >> isEnumDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> valueType: anObject [
	valueType := anObject
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> values [
	^ values
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> values: anObject [
	values := anObject
]
