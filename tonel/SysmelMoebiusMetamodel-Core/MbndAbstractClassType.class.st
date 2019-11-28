Class {
	#name : #MbndAbstractClassType,
	#superclass : #MbndAggregateTypeWithFields,
	#instVars : [
		'virtualMethods'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAbstractClassType class >> typeName [
	^ #_AbstractClassType
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> addChild: aChild [
	super addChild: aChild.
	(aChild isFunctionMethod or: [ aChild isMessageMethod ]) ifTrue: [
		aChild hasVirtualTableEntry ifTrue: [ self addVirtualMethod: aChild ]
	].
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> addVirtualMethod: aMethod [
	virtualMethods add: aMethod
]

{ #category : #layout }
MbndAbstractClassType >> buildSlotLayoutWith: builder [
	builder recordTypeStartLocation: self.
	self buildSuperTypesSlotLayoutWith: builder.
	(virtualMethods isNotEmpty and: [ self fields isEmpty or: [ fields first isVTablePointerField not ] ]) ifTrue: [
		builder createMainVirtualTable.
	].

	self fields do: [ :field |
		builder addField: field
	].

	virtualMethods do: [ :virtualMethod |
		builder addVirtualMethod: virtualMethod
	].

	builder recordTypeEndLocation: self.

]

{ #category : #initialization }
MbndAbstractClassType >> initialize [
	super initialize.
	virtualMethods := OrderedCollection new.
]

{ #category : #'testing methods' }
MbndAbstractClassType >> isAbstractClassType [
	^ true
]

{ #category : #'testing methods' }
MbndAbstractClassType >> isMetaTypeType [
	^ self hasFlag: #metaTypeType
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> markAsDefined [
	self addFlag: #defined
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> markAsMetaTypeType [
	^ self addFlag: #metaTypeType
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> methodDictionaryContent [
	| result identityHashField identityHashFieldBitMask |
	result := MbndMethodDictionaryContent for: self methodDict size.
	identityHashField := self compilationTarget managedObjectModel symbolClass slotLayout identityHashField.
	identityHashFieldBitMask := (1 << (identityHashField bits ifNil: [ identityHashField valueType instanceSize * 8 ])) - 1.
	
	methodDict keysAndValuesDo: [ :key :value |
		result withHash: (self compilationTarget identityHashForSymbol: key) & identityHashFieldBitMask putKey: key value: value
	].

	^ result
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> methodDictionaryInstanceObject [
	^ self methodDictionaryContent makeInstanceForCompilationTarget: self compilationTarget
]

{ #category : #accessing }
MbndAbstractClassType >> virtualMethods [
	^ virtualMethods
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> vtableFieldType [
	^ self compilationTarget voidType pointer pointer
]
