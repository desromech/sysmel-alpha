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

{ #category : #adding }
MbndAbstractClassType >> addConversionRulesToPointerType: pointerType [
	pointerType
		addExplicitConversionRule: MbndClassPointerTypeConversionRule new;
		addImplicitConversionRule: MbndClassImplicitUpcastTypeConversionRule new
]

{ #category : #adding }
MbndAbstractClassType >> addConversionRulesToReferenceType: referenceType [
	referenceType addImplicitConversionRule: MbndClassImplicitUpcastTypeConversionRule new
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> addVirtualMethod: aMethod [
	virtualMethods add: aMethod
]

{ #category : #layout }
MbndAbstractClassType >> buildSlotLayoutWith: builder [
	builder recordTypeStartLocation: self.
	self buildSuperTypesSlotLayoutWith: builder.
	virtualMethods ifNotEmpty: [
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

{ #category : #accessing }
MbndAbstractClassType >> virtualMethods [
	^ virtualMethods
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> vtableFieldType [
	^ self compilationTarget voidType pointer pointer
]
