Class {
	#name : #MbndFieldMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'bits',
		'location',
		'intrinsic'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #accessing }
MbndFieldMetaBuilder >> bits: bitCount [
	bits := bitCount
]

{ #category : #'semantic analysis' }
MbndFieldMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineField: name withValueType: valueType withInitialValue: initialValueNode)
		bits: bits;
		position: position;
		flags: flags;
		location: location;
		intrinsic: intrinsic;
		yourself.
	^ analyzer visitNode: result
]

{ #category : #accessing }
MbndFieldMetaBuilder >> intrinsic [
	^ intrinsic
]

{ #category : #accessing }
MbndFieldMetaBuilder >> intrinsic: anObject [
	intrinsic := anObject
]

{ #category : #accessing }
MbndFieldMetaBuilder >> location [
	^ location
]

{ #category : #accessing }
MbndFieldMetaBuilder >> location: anObject [
	location := anObject
]
