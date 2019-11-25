Trait {
	#name : #TMbndCoreManagedObjectModel,
	#instVars : [
		'compilationTarget',
		'sysmelMessageLookupFunction',
		'arrayClass',
		'byteArrayClass',
		'compiledMethodClass',
		'dictionaryClass',
		'methodDictionaryClass',
		'symbolClass',
		'stringClass',
		'integerClass',
		'floatClass'
	],
	#traits : 'TMbndAbstractManagedObjectModel',
	#classTraits : 'TMbndAbstractManagedObjectModel classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #accessing }
TMbndCoreManagedObjectModel >> arrayClass [
	^ arrayClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> arrayClass: anObject [
	arrayClass := anObject
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
TMbndCoreManagedObjectModel >> compiledMethodClass [
	^ compiledMethodClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> compiledMethodClass: anObject [
	compiledMethodClass := anObject
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
TMbndCoreManagedObjectModel >> floatClass [
	^ floatClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> floatClass: anObject [
	floatClass := anObject.
	compilationTarget literalIntegerType addConversionTo: floatClass rule: MbndLiteralValueTypeChangeConversionRule.
	compilationTarget literalFloatType addConversionTo: floatClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> integerClass [
	^ integerClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> integerClass: anObject [
	integerClass := anObject.
	compilationTarget literalIntegerType addConversionTo: integerClass rule: MbndLiteralValueTypeChangeConversionRule.
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
TMbndCoreManagedObjectModel >> symbolClass [
	^ symbolClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> symbolClass: anObject [
	symbolClass := anObject.
	compilationTarget literalSymbolType addConversionTo: symbolClass rule: MbndLiteralValueTypeChangeConversionRule.
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> sysmelMessageLookupFunction [
	^ sysmelMessageLookupFunction
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> sysmelMessageLookupFunction: anObject [
	sysmelMessageLookupFunction := anObject
]
