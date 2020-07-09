Class {
	#name : #MbndAbstractVariableMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'initialValueNode',
		'valueType',
		'alignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #accessing }
MbndAbstractVariableMetaBuilder >> alignment [
	^ alignment
]

{ #category : #accessing }
MbndAbstractVariableMetaBuilder >> alignment: anObject [
	alignment := anObject
]

{ #category : #definition }
MbndAbstractVariableMetaBuilder >> assignValue: newInitialValueNode [
	initialValueNode ifNotNil: [ self abortMetaBuilding ].
	initialValueNode := newInitialValueNode.
	^ self finishMetaBuilding
]

{ #category : #'as yet unclassified' }
MbndAbstractVariableMetaBuilder >> crossWorkgroupShared [
	self addFlag: #crossWorkgroupShared
	
]

{ #category : #mutability }
MbndAbstractVariableMetaBuilder >> inmutable [
	self removeFlag: #mutable
]

{ #category : #mutability }
MbndAbstractVariableMetaBuilder >> mutable [
	self addFlag: #mutable
]

{ #category : #mutability }
MbndAbstractVariableMetaBuilder >> ref [
	self addFlag: #ref
]

{ #category : #mutability }
MbndAbstractVariableMetaBuilder >> tempRef [
	self addFlag: #tempRef
]

{ #category : #accessing }
MbndAbstractVariableMetaBuilder >> type: typeExpression [
	valueType := typeExpression.

]

{ #category : #'as yet unclassified' }
MbndAbstractVariableMetaBuilder >> workgroupShared [
	self addFlag: #workgroupShared
	
]
