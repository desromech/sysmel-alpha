Class {
	#name : #MbndAbstractVariable,
	#superclass : #Object,
	#traits : 'TMbndVariable',
	#classTraits : 'TMbndVariable classTrait',
	#instVars : [
		'name',
		'definitionNode',
		'valueType'
	],
	#category : #'MoebiusBandMetamodel-Core-Variables'
}

{ #category : #accessing }
MbndAbstractVariable >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
MbndAbstractVariable >> definitionNode: anObject [
	definitionNode := anObject
]

{ #category : #accessing }
MbndAbstractVariable >> name [
	^ name
]

{ #category : #accessing }
MbndAbstractVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAbstractVariable >> type [
	^ valueType
]

{ #category : #accessing }
MbndAbstractVariable >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAbstractVariable >> valueType: anObject [
	valueType := anObject
]
