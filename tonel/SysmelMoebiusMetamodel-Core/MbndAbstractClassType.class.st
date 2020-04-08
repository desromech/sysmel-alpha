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
MbndAbstractClassType >> addMainVTableFieldNamed: fieldName [
	<compileTime>
	| fieldType vtableField |
	fieldType := self vtableFieldType.
	vtableField := MbndVTablePointerFieldVariable new
		name: fieldName;
		valueType: fieldType;
		type: fieldType ref.
	self addField: vtableField.
	^ vtableField
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> addVirtualMethod: aMethod [
	virtualMethods add: aMethod
]

{ #category : #layout }
MbndAbstractClassType >> buildSlotLayoutWith: builder [
	self evaluateAllPendingDefinitionFragments.
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

{ #category : #serialization }
MbndAbstractClassType >> encodeLazyFieldsForMessagePackWith: graphEncoder [
	^ (super encodeLazyFieldsForMessagePackWith: graphEncoder) , {
		#virtualMethods . virtualMethods encodeGraphForMessagePackWith: graphEncoder.
	}
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

{ #category : #testing }
MbndAbstractClassType >> isThrowable [
	^ (self hasFlag: #throwable) or: [ supertype isThrowable ]
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> markAsMetaTypeType [
	^ self addFlag: #metaTypeType
]

{ #category : #serialization }
MbndAbstractClassType >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields.
	
	virtualMethods := encodedFields at: #virtualMethods.
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> methodDictionaryContent [
	| result |
	result := MbndMethodDictionaryContent for: self methodDict size.
	
	methodDict keysAndValuesDo: [ :key :value |
		result withHash: (self compilationTarget identityHashForSymbolInDictionary: key)putKey: key value: value
	].

	^ result
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> methodDictionaryInstanceObject [
	^ self methodDictionaryContent makeInstanceForCompilationTarget: self compilationTarget
]

{ #category : #accessing }
MbndAbstractClassType >> virtualMethods [
	self evaluateAllPendingDefinitionFragments.
	^ virtualMethods
]

{ #category : #'as yet unclassified' }
MbndAbstractClassType >> vtableFieldType [
	^ self compilationTarget voidType pointer pointer
]
