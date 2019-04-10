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
MbndAstLocalVariableDefinition >> isAccessedByReference [
	^ self hasFlag: #ref
]

{ #category : #testing }
MbndAstLocalVariableDefinition >> isLocalVariableDefinitionNode [
	^ true
]

{ #category : #testing }
MbndAstLocalVariableDefinition >> isMutable [
	^ self hasFlag: #mutable
]

{ #category : #accessing }
MbndAstLocalVariableDefinition >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstLocalVariableDefinition >> valueType: anObject [
	valueType := anObject
]
