Class {
	#name : #SYMLGCClassInstance,
	#superclass : #SYMLObjectInstance,
	#instVars : [
		'slots',
		'ssaGlobalVariable'
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

{ #category : #'as yet unclassified' }
SYMLGCClassInstance >> generateSSAValueForModule: aModule [
	| ssaSlots |
	ssaGlobalVariable ifNotNil: [ ^ ssaGlobalVariable ].
	
	ssaGlobalVariable := SLVMGlobalVariable module: aModule ssaModule
		name: nil
		valueType: type structureSSAType
		storage: SLVMType genericStorage.
	ssaGlobalVariable makePrivate.
	
	ssaSlots := type slotsLayout collectWithIndex: [ :slot :index |
		slot type generateSSAConstant: (slots at: index) forModule: aModule
	].

	ssaGlobalVariable initialValue: (SLVMConstant structure: type structureSSAType slots: ssaSlots).
	^ ssaGlobalVariable
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

{ #category : #accessing }
SYMLGCClassInstance >> ssaGlobalVariable [
	^ ssaGlobalVariable
]

{ #category : #accessing }
SYMLGCClassInstance >> ssaGlobalVariable: anObject [
	ssaGlobalVariable := anObject
]
