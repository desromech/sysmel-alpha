Class {
	#name : #SYMLGCClassInstance,
	#superclass : #SYMLObjectInstance,
	#instVars : [
		'slots'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLGCClassInstance >> createSSAInitialValueConstant [
	| constantType module constantSlots |
	module := type module.
	constantSlots := type slotsLayout collectWithIndex: [ :slot :index |
		slot type generateSSAConstant: (slots at: index) forModule: module
	].

	constantType := type hasVariableDataArray ifTrue: [
		type structureSSATypeForVariableDataSize: slots last size.
	] ifFalse: [
		type structureSSAType
	].
	^ SLVMConstant structure: constantType slots: constantSlots
]

{ #category : #converting }
SYMLGCClassInstance >> generateSSAReferenceWith: builder [
	self halt.
]

{ #category : #initialization }
SYMLGCClassInstance >> setSlot: slotIndex value: aValue [
	slots at: slotIndex + 1 put: aValue
]

{ #category : #accessing }
SYMLGCClassInstance >> slots [
	^ slots
]

{ #category : #accessing }
SYMLGCClassInstance >> slots: anObject [
	slots := anObject
]
