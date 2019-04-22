Class {
	#name : #MbndAbstractVariableMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'initialValueNode',
		'valueType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #definition }
MbndAbstractVariableMetaBuilder >> assignValue: newInitialValueNode [
	initialValueNode ifNotNil: [ self abortMetaBuilding ].
	initialValueNode := newInitialValueNode
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
	self removeFlag: #ref
]

{ #category : #accessing }
MbndAbstractVariableMetaBuilder >> type: typeExpression [
	valueType := typeExpression.

]
