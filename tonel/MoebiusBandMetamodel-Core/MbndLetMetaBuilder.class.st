Class {
	#name : #MbndLetMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#category : #'MoebiusBandMetamodel-Core-MetaBuilder'
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
		position: position;
		yourself.
	^ analyzer visitNode: result
]
