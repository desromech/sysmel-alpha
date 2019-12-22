Trait {
	#name : #TMbndCoreManagedObjectModel,
	#instVars : [
		'compilationTarget',
		'arrayClass',
		'byteArrayClass',
		'compiledMethodClass',
		'dictionaryClass',
		'methodDictionaryClass',
		'symbolClass',
		'stringClass',
		'integerClass',
		'floatClass',
		'messageLookupFunction',
		'trueClass',
		'falseClass',
		'boolClass'
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
TMbndCoreManagedObjectModel >> boolClass [
	^ boolClass
]

{ #category : #accessing }
TMbndCoreManagedObjectModel >> boolClass: aClass [
	boolClass := aClass
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
