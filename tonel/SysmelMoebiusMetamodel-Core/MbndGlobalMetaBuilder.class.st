Class {
	#name : #MbndGlobalMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndGlobalMetaBuilder class >> globalBindingName [
	^ #global
]

{ #category : #'semantic analysis' }
MbndGlobalMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineGlobalVariable: name withValueType: valueType withInitialValue: initialValueNode)
		position: position;
		minimalAlignment: alignment;
		flags: flags;
		yourself.
	^ analyzer visitNode: result
]

{ #category : #flags }
MbndGlobalMetaBuilder >> externC [
	<compileTime>
	self addFlag: #externC
]
