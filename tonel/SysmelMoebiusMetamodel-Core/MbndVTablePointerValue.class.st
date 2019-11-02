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

{ #category : #testing }
MbndVTablePointerValue >> isVTablePointerValue [
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
