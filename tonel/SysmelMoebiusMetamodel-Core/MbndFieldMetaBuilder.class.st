Class {
	#name : #MbndFieldMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'semantic analysis' }
MbndFieldMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineField: name withValueType: valueType withInitialValue: initialValueNode)
		position: position;
		flags: flags;
		yourself.
	^ analyzer visitNode: result
]
