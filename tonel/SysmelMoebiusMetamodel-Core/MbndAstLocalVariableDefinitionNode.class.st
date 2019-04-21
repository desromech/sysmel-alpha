Class {
	#name : #MbndAstLocalVariableDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'valueType',
		'initialValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLocalVariableDefinitionNode >> accept: aVisitor [
	^ aVisitor visitLocalVariableDefinitionNode: self
]

{ #category : #flags }
MbndAstLocalVariableDefinitionNode >> immutable [
	self removeFlag: #mutable
]

{ #category : #accessing }
MbndAstLocalVariableDefinitionNode >> initialValue [
	^ initialValue
]

{ #category : #accessing }
MbndAstLocalVariableDefinitionNode >> initialValue: anObject [
	initialValue := anObject
]

{ #category : #testing }
MbndAstLocalVariableDefinitionNode >> isAccessedByReference [
	^ self hasFlag: #ref
]

{ #category : #testing }
MbndAstLocalVariableDefinitionNode >> isLocalVariableDefinitionNode [
	^ true
]

{ #category : #testing }
MbndAstLocalVariableDefinitionNode >> isMutable [
	^ self hasFlag: #mutable
]

{ #category : #flags }
MbndAstLocalVariableDefinitionNode >> mutable [
	self addFlag: #mutable
]

{ #category : #accessing }
MbndAstLocalVariableDefinitionNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstLocalVariableDefinitionNode >> valueType: anObject [
	valueType := anObject
]
