Class {
	#name : #MbndAstFieldDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
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
