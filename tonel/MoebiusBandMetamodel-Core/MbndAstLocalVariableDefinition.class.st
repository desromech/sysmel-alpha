Class {
	#name : #MbndAstLocalVariableDefinition,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'valueType',
		'initialValue'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLocalVariableDefinition >> accept: aVisitor [
	^ aVisitor visitLocalVariableDefinition: self
]

{ #category : #accessing }
MbndAstLocalVariableDefinition >> initialValue [
	^ initialValue
]

{ #category : #accessing }
MbndAstLocalVariableDefinition >> initialValue: anObject [
	initialValue := anObject
]

{ #category : #testing }
MbndAstLocalVariableDefinition >> isLocalVariableDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstLocalVariableDefinition >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstLocalVariableDefinition >> valueType: anObject [
	valueType := anObject
]
