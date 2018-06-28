Class {
	#name : #SYMLStructureInstance,
	#superclass : #SYMLObjectInstance,
	#instVars : [
		'slots'
	],
	#category : #'Sysmel-Metamodel-Program'
}

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
