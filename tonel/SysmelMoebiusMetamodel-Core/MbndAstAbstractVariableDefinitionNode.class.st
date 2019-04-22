Class {
	#name : #MbndAstAbstractVariableDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'initialValue',
		'valueType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #flags }
MbndAstAbstractVariableDefinitionNode >> immutable [
	self removeFlag: #mutable
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> initialValue [
	^ initialValue
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> initialValue: anObject [
	initialValue := anObject
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isAccessedByReference [
	^ self hasFlag: #ref
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isMutable [
	^ self hasFlag: #mutable
]

{ #category : #flags }
MbndAstAbstractVariableDefinitionNode >> mutable [
	self addFlag: #mutable
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> valueType: anObject [
	valueType := anObject
]
