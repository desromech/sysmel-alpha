Class {
	#name : #MbndAstAbstractVariableDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'initialValue',
		'initialValueKind',
		'valueType',
		'minimalAlignment'
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

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> initialValueKind [
	^ initialValueKind
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> initialValueKind: anObject [
	initialValueKind := anObject
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isAccessedByReference [
	^ self hasFlag: #ref
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isMutable [
	^ self hasFlag: #mutable
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isStatic [
	^ self hasFlag: #static
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> minimalAlignment [
	^ minimalAlignment
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> minimalAlignment: anObject [
	minimalAlignment := anObject
]

{ #category : #flags }
MbndAstAbstractVariableDefinitionNode >> mutable [
	self addFlag: #mutable
]

{ #category : #flags }
MbndAstAbstractVariableDefinitionNode >> ref [
	self addFlag: #ref
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> valueType: anObject [
	valueType := anObject
]
