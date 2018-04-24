Class {
	#name : #SYMLStructureInstance,
	#superclass : #SYMLObject,
	#instVars : [
		'type',
		'slots'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLStructureInstance >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: type inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLStructureInstance >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ type
]

{ #category : #'code generation' }
SYMLStructureInstance >> generateSSAReferenceWith: builder [
	| ssaType ssaSlots |
	ssaType := type ssaType.
	ssaSlots := type fields collectWithIndex: [ :field :index |
		field type generateSSAValue: (slots at: index) withBuilder: builder
	].

	^ SLVMConstantStructureValue new
		type: ssaType;
		slots: ssaSlots;
		yourself
]

{ #category : #accessing }
SYMLStructureInstance >> slots [
	^ slots
]

{ #category : #accessing }
SYMLStructureInstance >> slots: anObject [
	slots := anObject
]

{ #category : #accessing }
SYMLStructureInstance >> type [
	^ type
]

{ #category : #accessing }
SYMLStructureInstance >> type: anObject [
	type := anObject
]
