Class {
	#name : #MbndLetMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndLetMetaBuilder class >> globalBindingName [
	^ #let
]

{ #category : #'semantic analysis' }
MbndLetMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineLocalVariable: name withValueType: valueType withInitialValue: initialValueNode)
		minimalAlignment: alignment;
		flags: flags;
		yourself.
	^ analyzer visitNode: result
]
