Class {
	#name : #SYMLCompilationTarget,
	#superclass : #SYMLObject,
	#instVars : [
		'apsgNodeType',
		'compilerObjectType',
		'incompleteType',
		'literalArrayType',
		'literalSymbolType',
		'literalStringType',
		'literalCharacterType',
		'literalIntegerType',
		'literalFloatType',
		'literalFractionType',
		'booleanType',
		'voidType',
		'functionTypeTrait',
		'tupleTypeTrait',
		'functionTypeCache',
		'tupleTypeCache',
		'dynamicObjectType',
		'charType',
		'int8Type',
		'int16Type',
		'int32Type',
		'int64Type',
		'uint8Type',
		'uint16Type',
		'uint32Type',
		'uint64Type',
		'float32Type',
		'float64Type',
		'metaType'
	],
	#category : #'Sysmel-Metamodel-CompilationTarget'
}

{ #category : #construction }
SYMLCompilationTarget class >> x86 [
	^ SYMLSLVMCompilationTarget  target: SLVMCompilationTarget x86
]

{ #category : #construction }
SYMLCompilationTarget class >> x86_64 [
	^ SYMLSLVMCompilationTarget  target: SLVMCompilationTarget x86_64
]

{ #category : #accessing }
SYMLCompilationTarget >> apsgNodeType [
	<compileTime>
	^ apsgNodeType
]

{ #category : #accessing }
SYMLCompilationTarget >> apsgNodeType: anObject [
	<compileTime>
	apsgNodeType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> booleanType [
	<compileTime>
	^ booleanType
]

{ #category : #accessing }
SYMLCompilationTarget >> booleanType: anObject [
	<compileTime>
	booleanType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> charType [
	<compileTime>
	^ charType
]

{ #category : #accessing }
SYMLCompilationTarget >> charType: anObject [
	<compileTime>
	charType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> compilerObjectType [
	<compileTime>
	^ compilerObjectType
]

{ #category : #accessing }
SYMLCompilationTarget >> compilerObjectType: anObject [
	<compileTime>
	compilerObjectType := anObject
]

{ #category : #'target platform querying' }
SYMLCompilationTarget >> doubleAlignment [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLCompilationTarget >> dynamicObjectType [
	<compileTime>
	^ dynamicObjectType
]

{ #category : #accessing }
SYMLCompilationTarget >> dynamicObjectType: anObject [
	<compileTime>
	dynamicObjectType := anObject
]

{ #category : #'as yet unclassified' }
SYMLCompilationTarget >> fakeEnvironment [
	^ SYMLCompilationTargetFakeScope new compilationTarget: self
]

{ #category : #accessing }
SYMLCompilationTarget >> float32Type [
	<compileTime>
	^ float32Type
]

{ #category : #accessing }
SYMLCompilationTarget >> float32Type: anObject [
	<compileTime>
	float32Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> float64Type [
	<compileTime>
	^ float64Type
]

{ #category : #accessing }
SYMLCompilationTarget >> float64Type: anObject [
	<compileTime>
	float64Type := anObject
]

{ #category : #'builder methods' }
SYMLCompilationTarget >> functionArguments: argumentTypes returnType: returnType callingConvention: callingConvention variadic: variadic [
	| functionType |
	functionType := SYMLFunctionType new
		compilationTarget: self;
		addTrait: functionTypeTrait;
		arguments: argumentTypes;
		returnType: returnType;
		callingConvention: callingConvention;
		variadic: variadic;
		yourself.
	^ functionTypeCache at: functionType ifAbsentPut: [ functionType ]
	

]

{ #category : #accessing }
SYMLCompilationTarget >> functionTypeTrait [
	<compileTime>
	^ functionTypeTrait
]

{ #category : #accessing }
SYMLCompilationTarget >> functionTypeTrait: anObject [
	<compileTime>
	functionTypeTrait := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> incompleteType [
	<compileTime>
	^ incompleteType
]

{ #category : #accessing }
SYMLCompilationTarget >> incompleteType: anObject [
	<compileTime>
	incompleteType := anObject
]

{ #category : #initialization }
SYMLCompilationTarget >> initialize [
	super initialize.
	functionTypeCache := Dictionary new.
	tupleTypeCache := Dictionary new.
]

{ #category : #accessing }
SYMLCompilationTarget >> int16Type [
	<compileTime>
	^ int16Type
]

{ #category : #accessing }
SYMLCompilationTarget >> int16Type: anObject [
	<compileTime>
	int16Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> int32Type [
	<compileTime>
	^ int32Type
]

{ #category : #accessing }
SYMLCompilationTarget >> int32Type: anObject [
	<compileTime>
	int32Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> int64Type [
	<compileTime>
	^ int64Type
]

{ #category : #accessing }
SYMLCompilationTarget >> int64Type: anObject [
	<compileTime>
	int64Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> int8Type [
	<compileTime>
	^ int8Type
]

{ #category : #accessing }
SYMLCompilationTarget >> int8Type: anObject [
	<compileTime>
	int8Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalArrayType [
	<compileTime>
	^ literalArrayType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalArrayType: anObject [
	<compileTime>
	literalArrayType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalCharacterType [
	<compileTime>
	^ literalCharacterType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalCharacterType: anObject [
	<compileTime>
	literalCharacterType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalFloatType [
	<compileTime>
	^ literalFloatType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalFloatType: anObject [
	<compileTime>
	literalFloatType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalFractionType [
	<compileTime>
	^ literalFractionType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalFractionType: anObject [
	<compileTime>
	literalFractionType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalIntegerType [
	<compileTime>
	^ literalIntegerType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalIntegerType: anObject [
	<compileTime>
	literalIntegerType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalStringType [
	<compileTime>
	^ literalStringType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalStringType: anObject [
	<compileTime>
	literalStringType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> literalSymbolType [
	<compileTime>
	^ literalSymbolType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalSymbolType: anObject [
	<compileTime>
	literalSymbolType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> metaType [
	<compileTime>
	^ metaType
]

{ #category : #accessing }
SYMLCompilationTarget >> metaType: aType [
	<compileTime>
	metaType := aType
]

{ #category : #'target platform querying' }
SYMLCompilationTarget >> pointerAlignment [
	self subclassResponsibility
]

{ #category : #'target platform querying' }
SYMLCompilationTarget >> pointerSize [
	self subclassResponsibility
]

{ #category : #'builder methods' }
SYMLCompilationTarget >> tuple: aCollectionOfTypes [
	| tuple |
	tuple := SYMLTupleType new
		compilationTarget: self;
		addTrait: tupleTypeTrait;
		types: aCollectionOfTypes asArray;
		yourself.
	^ tupleTypeCache at: tuple ifAbsentPut: [ tuple ]
]

{ #category : #accessing }
SYMLCompilationTarget >> tupleTypeTrait [
	<compileTime>
	^ tupleTypeTrait
]

{ #category : #accessing }
SYMLCompilationTarget >> tupleTypeTrait: anObject [
	<compileTime>
	tupleTypeTrait := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> uint16Type [
	<compileTime>
	^ uint16Type
]

{ #category : #accessing }
SYMLCompilationTarget >> uint16Type: anObject [
	<compileTime>
	uint16Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> uint32Type [
	<compileTime>
	^ uint32Type
]

{ #category : #accessing }
SYMLCompilationTarget >> uint32Type: anObject [
	<compileTime>
	uint32Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> uint64Type [
	<compileTime>
	^ uint64Type
]

{ #category : #accessing }
SYMLCompilationTarget >> uint64Type: anObject [
	<compileTime>
	uint64Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> uint8Type [
	<compileTime>
	^ uint8Type
]

{ #category : #accessing }
SYMLCompilationTarget >> uint8Type: anObject [
	<compileTime>
	uint8Type := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> voidType [
	<compileTime>
	^ voidType
]

{ #category : #accessing }
SYMLCompilationTarget >> voidType: anObject [
	<compileTime>
	voidType := anObject
]
