Class {
	#name : #SYMLGCClassInstance,
	#superclass : #SYMLStructureInstance,
	#instVars : [
		'ssaGlobalVariable',
		'ssaGlobalVariableReference'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLGCClassInstance >> generateSSAReferenceWith: builder [
	self halt.
]

{ #category : #'as yet unclassified' }
SYMLGCClassInstance >> generateSSAValueForModule: aModule [
	ssaGlobalVariableReference ifNotNil: [ ^ ssaGlobalVariableReference ].
	
	ssaGlobalVariable := SLVMGlobalVariable module: aModule ssaModule
		name: nil
		valueType: self ssaInitialValueType
		storage: SLVMType genericStorage.
	ssaGlobalVariable makePrivate.
	ssaGlobalVariableReference := SLVMConstant value: ssaGlobalVariable bitcast: type ssaType.
	
	ssaGlobalVariable initialValue: self createSSAInitialValueConstant.
	^ ssaGlobalVariableReference
]

{ #category : #initialization }
SYMLGCClassInstance >> setSlot: slotIndex value: aValue [
	slots at: slotIndex + 1 put: aValue
]

{ #category : #accessing }
SYMLGCClassInstance >> ssaGlobalVariable [
	^ ssaGlobalVariable
]

{ #category : #accessing }
SYMLGCClassInstance >> ssaGlobalVariable: anObject [
	ssaGlobalVariable := anObject
]

{ #category : #converting }
SYMLGCClassInstance >> ssaInitialValueType [
	^ type hasVariableDataArray ifTrue: [
		type structureSSATypeForVariableDataSize: slots last size.
	] ifFalse: [
		type structureSSAType
	]
]

{ #category : #'as yet unclassified' }
SYMLGCClassInstance >> sysmelIdentityHash [
	^ type readIdentityHashFromSlots: slots
]
