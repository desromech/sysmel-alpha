Class {
	#name : #MbndVTablePointerFieldVariable,
	#superclass : #MbndAbstractFieldVariable,
	#instVars : [
		'vtableSlots',
		'vtableSelectorDictionary'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndVTablePointerFieldVariable >> accept: aVisitor [
	^ aVisitor visitVTablePointerFieldVariable: self
]

{ #category : #'vtable slots' }
MbndVTablePointerFieldVariable >> addNewVirtualMethodEntry: method [
	| selector |
	selector := method virtualTableSelector.
	(vtableSelectorDictionary includesKey: selector) ifTrue: [
		self warning: 'Virtual method {1} shadows an already defined virtual method in a super class.' format: { method name asPrettySymbolName} at: method declarationPosition
	].

	vtableSlots add: method.
	vtableSelectorDictionary at: selector put: vtableSlots size - 1.
]

{ #category : #accessing }
MbndVTablePointerFieldVariable >> defaultValueAt: aPosition [
	^ MbndVTablePointerValue new vtableFieldDefinition: self
]

{ #category : #accessing }
MbndVTablePointerFieldVariable >> firstMethodSlotIndex [
	^ 2
]

{ #category : #'vtable slots' }
MbndVTablePointerFieldVariable >> getSlotIndexFor: virtualTableSelector [
	^ vtableSelectorDictionary at: virtualTableSelector
]

{ #category : #initialization }
MbndVTablePointerFieldVariable >> initialize [
	super initialize.
	vtableSlots := OrderedCollection new.
	vtableSelectorDictionary := Dictionary new.
]

{ #category : #testing }
MbndVTablePointerFieldVariable >> isVTablePointerField [
	^ true
]

{ #category : #'vtable slots' }
MbndVTablePointerFieldVariable >> overrideVirtualMethodEntryWith: method [
	(self tryToOverrideVirtualMethodEntryWith: method) ifFalse: [ 
		self error: 'Method {1} does not override any method defined in a super class.' format: { method name asPrettySymbolName } at: method declarationPosition
	].
]

{ #category : #'vtable slots' }
MbndVTablePointerFieldVariable >> tryToOverrideVirtualMethodEntryWith: method [
	| selector |
	selector := method virtualTableSelector.
	
	vtableSelectorDictionary at: selector ifPresent: [ :vtableSlotIndex |
		vtableSlots at: vtableSlotIndex + 1 put: method
	] ifAbsent: [ ^ false ].
	
	^ true
]

{ #category : #accessing }
MbndVTablePointerFieldVariable >> vtableSlots [
	^ vtableSlots
]
