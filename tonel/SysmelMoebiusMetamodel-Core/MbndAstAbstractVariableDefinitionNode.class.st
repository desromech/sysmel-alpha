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

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> constructionPriority [
	^ nil
]

{ #category : #serialization }
MbndAstAbstractVariableDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#initialValue . initialValue encodeGraphForMessagePackWith: graphEncoder.
		#initialValueKind . initialValueKind.
		#valueType. valueType encodeGraphForMessagePackWith: graphEncoder.
		#minimalAlignment. minimalAlignment.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

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
MbndAstAbstractVariableDefinitionNode >> isForwardingValue [
	^ self hasFlag: #tempRef
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isMutable [
	^ self hasFlag: #mutable
]

{ #category : #testing }
MbndAstAbstractVariableDefinitionNode >> isStatic [
	^ self hasFlag: #static
]

{ #category : #serialization }
MbndAstAbstractVariableDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	initialValue := encodedFields at: #initialValue.
	initialValueKind := encodedFields at: #initialValueKind.
	valueType := encodedFields at: #valueType.
	minimalAlignment := encodedFields at: #minimalAlignment.
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

{ #category : #flags }
MbndAstAbstractVariableDefinitionNode >> tempRef [
	self addFlag: #tempRef
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstAbstractVariableDefinitionNode >> valueType: anObject [
	valueType := anObject
]
