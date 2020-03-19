Class {
	#name : #MbndVTablePointerValue,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'vtableFieldDefinition'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndVTablePointerValue class >> messagePackTypeName [
	^ #VTablePointerValue
]

{ #category : #'as yet unclassified' }
MbndVTablePointerValue >> isMbndVTablePointerValue [
	^ true
]

{ #category : #evaluating }
MbndVTablePointerValue >> type [
	^ vtableFieldDefinition valueType
]

{ #category : #evaluating }
MbndVTablePointerValue >> value [
	^ self
]

{ #category : #accessing }
MbndVTablePointerValue >> vtableFieldDefinition [
	^ vtableFieldDefinition
]

{ #category : #accessing }
MbndVTablePointerValue >> vtableFieldDefinition: anObject [
	vtableFieldDefinition := anObject
]
