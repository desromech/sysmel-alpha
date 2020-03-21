Class {
	#name : #MbndVTablePointerFieldVariable,
	#superclass : #MbndAbstractFieldVariable,
	#instVars : [
		'vtableSlots',
		'vtableSelectorDictionary'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndVTablePointerFieldVariable class >> messagePackTypeName [
	^ #VTablePointerField
]

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

{ #category : #serialization }
MbndVTablePointerFieldVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#vtableSlots . vtableSlots encodeGraphForMessagePackWith: graphEncoder.
	}
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

{ #category : #serialization }
MbndVTablePointerFieldVariable >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	vtableSlots := encodedFields at: #vtableSlots ifAbsent: [ nil ].
	vtableSlots doWithIndex: [ :vslotMethod :vslotIndex |
		| selector |
		selector := vslotMethod virtualTableSelector.
		self assert: selector isNotNil.
		vtableSelectorDictionary at: selector put: vslotIndex - 1
	]
]

{ #category : #'vtable slots' }
MbndVTablePointerFieldVariable >> overrideVirtualMethodEntryWith: method [
	(self tryToOverrideVirtualMethodEntryWith: method) ifFalse: [ 
		self error: 'Method {1} does not override any method defined in a super class.' format: { method name asPrettySymbolName } at: method declarationPosition
	].
]

{ #category : #printing }
MbndVTablePointerFieldVariable >> printOn: aStream [
	aStream nextPutAll: parent qualifiedName; nextPutAll: '::<vtable:'; print: slotIndex; nextPut: $>
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
