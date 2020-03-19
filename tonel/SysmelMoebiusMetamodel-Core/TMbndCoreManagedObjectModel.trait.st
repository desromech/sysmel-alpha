Trait {
	#name : #TMbndCoreManagedObjectModel,
	#instVars : [
		'compilationTarget',
		'additionalBindingClass',
		'additionalMethodStateClass',
		'arrayClass',
		'associationClass',
		'byteArrayClass',
		'classVariableClass',
		'compiledMethodClass',
		'dictionaryClass',
		'identityDictionaryClass',
		'systemDictionaryClass',
		'methodDictionaryClass',
		'symbolClass',
		'stringClass',
		'integerClass',
		'floatClass',
		'globalVariableClass',
		'messageLookupFunction',
		'trueClass',
		'falseClass',
		'boolClass',
		'undeclaredVariableClass',
		'workspaceVariableClass',
		'associationValueOffset',
		'characterClass',
		'int32ToIntegerFunction',
		'uint32ToIntegerFunction',
		'int64ToIntegerFunction',
		'uint64ToIntegerFunction',
		'uint32ToCharacterFunction',
		'float64ToFloatFunction',
		'blockClosureHeaderClass',
		'blockClosureClass',
		'gcBlockClosureAllocationFunction',
		'objectToUInt32Function',
		'objectToInt32Function',
		'objectToUInt64Function',
		'objectToInt64Function',
		'objectToChar32Function',
		'objectToFloat64Function',
		'objectToBoolean8Function',
		'messageClass',
		'moduleRootRegistrationFunction',
		'moduleRootUnregistrationFunction',
		'gcLayoutClass',
		'receiverClassGetter',
		'methodSuperClassGetter',
		'inlineCacheStructure',
		'identityHashFieldBitMask'
	],
	#traits : 'TMbndAbstractManagedObjectModel',
	#classTraits : 'TMbndAbstractManagedObjectModel classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #accessing }
TMbndCoreManagedObjectModel >> additionalBindingClass [
	^ additionalBindingClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> additionalBindingClass: anObject [
	additionalBindingClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> additionalMethodStateClass [
	^ additionalMethodStateClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> additionalMethodStateClass: anObject [
	additionalMethodStateClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> arrayClass [
	^ arrayClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> arrayClass: anObject [
	arrayClass := anObject.
	compilationTarget literalArrayType addConversionTo: arrayClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> associationClass [
	^ associationClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> associationClass: anObject [
	associationClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> associationValueOffset [
	^ associationValueOffset ifNil: [associationValueOffset := associationClass getFieldOffset: #value]
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> blockClosureClass [
	^ blockClosureClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> blockClosureClass: anObject [
	blockClosureClass := anObject.
	compilationTarget gcBlockClosureType addConversionTo: blockClosureClass rule: MbndPointerReinterpretTypeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> blockClosureHeaderClass [
	^ blockClosureHeaderClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> blockClosureHeaderClass: anObject [
	blockClosureHeaderClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> boolClass [
	^ boolClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> boolClass: aClass [
	boolClass := aClass.
	compilationTarget booleanType addConversionTo: boolClass rule: MbndBooleanToDynamicObjectConversionRule.
	compilationTarget dynamicObjectType addExplicitConversionRule: (MbndDynamicObjectToBooleanConversionRule when: [:sourceType :targetType |
		targetType isPrimitiveBooleanType
	]).
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> byteArrayClass [
	^ byteArrayClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> byteArrayClass: anObject [
	byteArrayClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> characterClass [
	^ characterClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> characterClass: anObject [
	characterClass := anObject.
	compilationTarget literalCharacterType addConversionTo: characterClass rule: MbndLiteralValueTypeChangeConversionRule.
	compilationTarget primitiveCharacterCodeType addConversionTo: characterClass rule: MbndCharacterToDynamicObjectConversionRule.
	compilationTarget dynamicObjectType addExplicitConversionRule: (MbndDynamicObjectToCharacterConversionRule when: [:sourceType :targetType |
		targetType isPrimitiveCharacterCodeType
	]).
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> classVariableClass [
	^ classVariableClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> classVariableClass: anObject [
	classVariableClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> compiledMethodClass [
	^ compiledMethodClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> compiledMethodClass: anObject [
	compiledMethodClass := anObject
]

{ #category : #converting }
TMbndCoreManagedObjectModel >> computeBytesHash: data [
	^ self computeBytesHash: data initialHash: 5381
]

{ #category : #converting }
TMbndCoreManagedObjectModel >> computeBytesHash: data initialHash: initialHash [
	"
	https://en.wikipedia.org/wiki/Universal_hashing
	"
	| result |
	self flag: 'TODO: Perform a benchmark to pick these constants.'.
	result := initialHash.
	result := (result*33 + data size) & 16rFFFFFFFF.
	data do: [ :x |
		result := (result*33 + x) & 16rFFFFFFFF.
	].

	^ result
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> dictionaryClass [
	^ dictionaryClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> dictionaryClass: anObject [
	dictionaryClass := anObject
]

{ #category : #serialization }
TMbndCoreManagedObjectModel >> encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder [
	^ Array streamContents: [:out |
		#(
			additionalBindingClass additionalMethodStateClass arrayClass associationClass
			byteArrayClass classVariableClass compiledMethodClass dictionaryClass identityDictionaryClass
			systemDictionaryClass methodDictionaryClass symbolClass stringClass integerClass floatClass
			globalVariableClass messageLookupFunction trueClass falseClass boolClass
			undeclaredVariableClass workspaceVariableClass characterClass
			int32ToIntegerFunction uint32ToIntegerFunction int64ToIntegerFunction uint64ToIntegerFunction
			uint32ToCharacterFunction float64ToFloatFunction blockClosureHeaderClass blockClosureClass
			gcBlockClosureAllocationFunction objectToUInt32Function objectToInt32Function objectToUInt64Function
			objectToInt64Function objectToChar32Function objectToFloat64Function
			objectToBoolean8Function messageClass moduleRootRegistrationFunction
			moduleRootUnregistrationFunction gcLayoutClass receiverClassGetter methodSuperClassGetter
			inlineCacheStructure) do: [ :selector |
				| object|
				object := self perform: selector.
				object ifNotNil: [
					out nextPut: selector; nextPut: (object encodeGraphForMessagePackWith: graphEncoder)
				]
		]
	]
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> falseClass [
	^ falseClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> falseClass: anObject [
	falseClass := anObject.
	compilationTarget literalBooleanFalseType addConversionTo: falseClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> float64ToFloatFunction [
	^ float64ToFloatFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> float64ToFloatFunction: anObject [
	float64ToFloatFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> floatClass [
	^ floatClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> floatClass: anObject [
	floatClass := anObject.
	compilationTarget literalIntegerType addConversionTo: floatClass rule: MbndLiteralValueTypeChangeConversionRule.
	compilationTarget literalFloatType addConversionTo: floatClass rule: MbndLiteralValueTypeChangeConversionRule.
	compilationTarget primitiveFloatType addConversionTo: floatClass rule: MbndFloatToDynamicObjectConversionRule.
	compilationTarget dynamicObjectType addExplicitConversionRule: (MbndDynamicObjectToFloatConversionRule when: [:sourceType :targetType |
		targetType isPrimitiveFloatType
	]).
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> gcBlockClosureAllocationFunction [
	^ gcBlockClosureAllocationFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> gcBlockClosureAllocationFunction: aFunction [
	gcBlockClosureAllocationFunction := aFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> gcLayoutClass [
	^ gcLayoutClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> gcLayoutClass: anObject [
	gcLayoutClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> globalVariableClass [
	^ globalVariableClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> globalVariableClass: anObject [
	globalVariableClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> identityDictionaryClass [
	^ identityDictionaryClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> identityDictionaryClass: anObject [
	identityDictionaryClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> identityHashFieldBitMask [
	^ identityHashFieldBitMask ifNil: [
		| identityHashField |
		identityHashField := symbolClass slotLayout identityHashField.
		identityHashFieldBitMask := (1 << (identityHashField bits ifNil: [ identityHashField valueType instanceSize * 8 ])) - 1
	]
]

{ #category : #'as yet unclassified' }
TMbndCoreManagedObjectModel >> identityHashForSymbol: aSymbol [
	^ self computeBytesHash: aSymbol utf8Encoded initialHash: 5381
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> inlineCacheStructure [
	^ inlineCacheStructure
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> inlineCacheStructure: anObject [
	inlineCacheStructure := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> int32ToIntegerFunction [
	^ int32ToIntegerFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> int32ToIntegerFunction: anObject [
	int32ToIntegerFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> int64ToIntegerFunction [
	^ int64ToIntegerFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> int64ToIntegerFunction: anObject [
	int64ToIntegerFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> integerClass [
	^ integerClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> integerClass: anObject [
	integerClass := anObject.
	compilationTarget literalIntegerType addConversionTo: integerClass rule: MbndLiteralValueTypeChangeConversionRule.
	compilationTarget primitiveIntegerType addConversionTo: integerClass rule: MbndIntegerToDynamicObjectConversionRule.
	compilationTarget dynamicObjectType addExplicitConversionRule: (MbndDynamicObjectToIntegerConversionRule when: [:sourceType :targetType |
		targetType isPrimitiveIntegerType and: [ targetType isPrimitiveCharacterCodeType not ]
	]).
]

{ #category : #serialization }
TMbndCoreManagedObjectModel >> materializeBootstrapDefinedObjectWithGraphDecoder: graphDecoder withFields: encodedFields [
	encodedFields keysAndValuesDo: [ :key :value |
		value ifNotNil: [ self perform: (key , ':') asSymbol with: value ]
	]
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> messageClass [
	^ messageClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> messageClass: anObject [
	messageClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> messageLookupFunction [
	^ messageLookupFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> messageLookupFunction: anObject [
	messageLookupFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> methodDictionaryClass [
	^ methodDictionaryClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> methodDictionaryClass: anObject [
	methodDictionaryClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> methodSuperClassGetter [
	^ methodSuperClassGetter
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> methodSuperClassGetter: anObject [
	methodSuperClassGetter := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> moduleRootRegistrationFunction [
	^ moduleRootRegistrationFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> moduleRootRegistrationFunction: anObject [
	moduleRootRegistrationFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> moduleRootUnregistrationFunction [
	^ moduleRootUnregistrationFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> moduleRootUnregistrationFunction: anObject [
	moduleRootUnregistrationFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToBoolean8Function [
	^ objectToBoolean8Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToBoolean8Function: aFunction [
	objectToBoolean8Function := aFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToChar32Function [
	^ objectToChar32Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToChar32Function: anObject [
	objectToChar32Function := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToFloat64Function [
	^ objectToFloat64Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToFloat64Function: anObject [
	objectToFloat64Function := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToInt32Function [
	^ objectToInt32Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToInt32Function: anObject [
	objectToInt32Function := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToInt64Function [
	^ objectToInt64Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToInt64Function: anObject [
	objectToInt64Function := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToUInt32Function [
	^ objectToUInt32Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToUInt32Function: anObject [
	objectToUInt32Function := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToUInt64Function [
	^ objectToUInt64Function
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> objectToUInt64Function: anObject [
	objectToUInt64Function := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> receiverClassGetter [
	^ receiverClassGetter
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> receiverClassGetter: anObject [
	receiverClassGetter := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> stringClass [
	^ stringClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> stringClass: anObject [
	stringClass := anObject.
	compilationTarget literalStringType addConversionTo: stringClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> symbolClass [
	^ symbolClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> symbolClass: anObject [
	symbolClass := anObject.
	compilationTarget literalSymbolType addConversionTo: symbolClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> systemDictionaryClass [
	^ systemDictionaryClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> systemDictionaryClass: anObject [
	systemDictionaryClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> trueClass [
	^ trueClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> trueClass: anObject [
	trueClass := anObject.
	compilationTarget literalBooleanTrueType addConversionTo: trueClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> uint32ToCharacterFunction [
	^ uint32ToCharacterFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> uint32ToCharacterFunction: anObject [
	uint32ToCharacterFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> uint32ToIntegerFunction [
	^ uint32ToIntegerFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> uint32ToIntegerFunction: anObject [
	uint32ToIntegerFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> uint64ToIntegerFunction [
	^ uint64ToIntegerFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> uint64ToIntegerFunction: anObject [
	uint64ToIntegerFunction := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> undeclaredVariableClass [
	^ undeclaredVariableClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> undeclaredVariableClass: anObject [
	undeclaredVariableClass := anObject
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> workspaceVariableClass [
	^ workspaceVariableClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> workspaceVariableClass: anObject [
	workspaceVariableClass := anObject
]
