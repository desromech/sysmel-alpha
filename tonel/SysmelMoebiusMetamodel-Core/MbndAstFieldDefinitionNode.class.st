Class {
	#name : #MbndAstFieldDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'bits',
		'location',
		'intrinsic'
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

{ #category : #accessing }
MbndAstFieldDefinitionNode >> intrinsic [
	^ intrinsic
]

{ #category : #accessing }
MbndAstFieldDefinitionNode >> intrinsic: anObject [
	intrinsic := anObject
]

{ #category : #testing }
MbndAstFieldDefinitionNode >> isFieldDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstFieldDefinitionNode >> location [
	^ location
]

{ #category : #accessing }
MbndAstFieldDefinitionNode >> location: anObject [
	location := anObject
]
