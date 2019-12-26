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
		'superMessageLookupFunction',
		'undeclaredVariableClass',
		'workspaceVariableClass',
		'associationValueOffset'
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
	arrayClass := anObject
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
TMbndCoreManagedObjectModel >> classVariableClass [
	^ classVariableClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> classVariableClass: anObject [
	classVariableClass := anObject
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
TMbndCoreManagedObjectModel >> globalVariableClass [
	^ globalVariableClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> globalVariableClass: anObject [
	globalVariableClass := anObject
]

{ #category : #'as yet unclassified' }
TMbndCoreManagedObjectModel >> identityHashForSymbol: aSymbol [
	^ self computeBytesHash: aSymbol utf8Encoded initialHash: 5381
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
		targetType isPrimitiveIntegerType
	]).
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
TMbndCoreManagedObjectModel >> stringClass [
	^ stringClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> stringClass: anObject [
	stringClass := anObject.
	compilationTarget literalStringType addConversionTo: stringClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> superMessageLookupFunction [
	^ superMessageLookupFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> superMessageLookupFunction: anObject [
	superMessageLookupFunction := anObject
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
TMbndCoreManagedObjectModel >> trueClass [
	^ trueClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> trueClass: anObject [
	trueClass := anObject.
	compilationTarget literalBooleanTrueType addConversionTo: trueClass rule: MbndLiteralValueTypeChangeConversionRule.
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
