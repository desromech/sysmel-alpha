Class {
	#name : #MbndLetMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndLetMetaBuilder class >> globalBindingName [
	^ #let
]

{ #category : #'as yet unclassified' }
MbndLetMetaBuilder >> applyWithArguments: tuple [
	^ self subscriptAt: tuple
]

{ #category : #'semantic analysis' }
MbndLetMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineLocalVariable: name withValueType: valueType withInitialValue: initialValueNode)
		position: position;
		minimalAlignment: alignment;
		flags: flags;
		yourself.
	^ analyzer visitNode: result
]

{ #category : #'as yet unclassified' }
MbndLetMetaBuilder >> subscriptAt: patternNode [
	^ self delegateToMetaBuilder: (MbndDestructuringAssignmentMetaBuilder new
		patternNode: patternNode;
		yourself)
]
