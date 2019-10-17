Class {
	#name : #MbndAstFieldDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'bits'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFieldDefinitionNode >> accept: aVisitor [
	^ aVisitor visitFieldDefinitionNode: self
]

{ #category : #accessing }
MbndAstFieldDefinitionNode >> bits [
	^ bits
]

{ #category : #accessing }
MbndAstFieldDefinitionNode >> bits: anObject [
	bits := anObject
]

{ #category : #testing }
MbndAstFieldDefinitionNode >> isFieldDefinitionNode [
	^ true
]
