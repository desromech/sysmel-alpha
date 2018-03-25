Class {
	#name : #SYMLSLVMCompilationTarget,
	#superclass : #SYMLCompilationTarget,
	#instVars : [
		'lowLevelTarget',
		'booleanType',
		'uint8Type',
		'uint16Type',
		'uint32Type',
		'uint64Type',
		'int8Type',
		'int16Type',
		'int32Type',
		'int64Type',
		'float32Type',
		'float64Type',
		'characterType',
		'literalIntegerType',
		'literalFloatType',
		'literalCharacterType',
		'builtInTypes',
		'astNodeType',
		'metaTypes',
		'compilerObjectType',
		'constTypes',
		'pointerTypes',
		'referenceTypes',
		'volatileTypes',
		'voidType',
		'functionTypes',
		'apsgNodeType',
		'literalStringType',
		'literalSymbolType',
		'literalArrayType',
		'tupleTypes',
		'literalBooleanType'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'instance creation' }
SYMLSLVMCompilationTarget class >> for: aLowLevelCompilationTarget [
	^ self basicNew initializeWithLowLevelTarget: aLowLevelCompilationTarget
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> apsgNodeType [
	^ apsgNodeType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> astNodeType [
	^ astNodeType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> booleanType [
	^ booleanType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> builtInTypes [
	^ builtInTypes
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> characterType [
	^ characterType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> compilerObjectType [
	^ compilerObjectType
]

{ #category : #'composite types' }
SYMLSLVMCompilationTarget >> constOfType: valueType [
	valueType isConstantType ifTrue: [ ^ valueType ].
	^ constTypes at: valueType ifAbsentPut: [ SYMLConstType new target: self; decorated: valueType ]
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> float32Type [
	^ float32Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> float64Type [
	^ float64Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> functionArguments: argumentTypes returnType: returnType callingConvention: callingConvention variadic: variadic [
	| functionType |
	functionType := SYMLFunctionType new
		target: self;
		arguments: argumentTypes;
		returnType: returnType;
		callingConvention: callingConvention;
		variadic: variadic;
		yourself.
	^ functionTypes at: functionType ifAbsentPut: [ functionType ]
]

{ #category : #initialization }
SYMLSLVMCompilationTarget >> initializeWithLowLevelTarget: aLowLevelCompilationTarget [
	lowLevelTarget := aLowLevelCompilationTarget.

	metaTypes := IdentityDictionary new.
	constTypes := IdentityDictionary new.
	volatileTypes := IdentityDictionary new.
	pointerTypes := IdentityDictionary new.
	referenceTypes := IdentityDictionary new.
	functionTypes := WeakValueDictionary new.
	tupleTypes := WeakValueDictionary new.
	
	builtInTypes := {
		voidType := SYMLVoidType new target: self.
		
		booleanType := SYMLBooleanType new target: self; name: #Boolean; size: 1; alignment: 1; ssaType: lowLevelTarget bool.
		uint8Type := SYMLIntegerType new target: self; name: #UInt8; signed: false; size: 1; alignment: 1; ssaType: lowLevelTarget uint8.
		uint16Type := SYMLIntegerType new target: self; name: #UInt16; signed: false; size: 2; alignment: 2; ssaType: lowLevelTarget uint16.
		uint32Type := SYMLIntegerType new target: self; name: #UInt32; signed: false; size: 4; alignment: 4; ssaType: lowLevelTarget uint32.
		uint64Type := SYMLIntegerType new target: self; name: #UInt64; signed: false; size: 8; alignment: 8; ssaType: lowLevelTarget uint64.

		int8Type := SYMLIntegerType new target: self; name: #Int8; signed: true; size: 1; alignment: 1; ssaType: lowLevelTarget int8.
		int16Type := SYMLIntegerType new target: self; name: #Int16; signed: true; size: 2; alignment: 2; ssaType: lowLevelTarget int16.
		int32Type := SYMLIntegerType new target: self; name: #Int32; signed: true; size: 4; alignment: 4; ssaType: lowLevelTarget int32.
		int64Type := SYMLIntegerType new target: self; name: #Int64; signed: true; size: 8; alignment: 8; ssaType: lowLevelTarget int64.

		float32Type := SYMLIntegerType new target: self; name: #Float32; signed: true; size: 4; alignment: 4; ssaType: lowLevelTarget float32.
		float64Type := SYMLIntegerType new target: self; name: #Float64; signed: true; size: 8; alignment: (lowLevelTarget double alignment); ssaType: lowLevelTarget float64.

		characterType := SYMLAliasType for: uint8Type name: #Char.
	
		astNodeType := SYMLASTNodeType new target: self.
		apsgNodeType := SYMLAPSGNodeType new target: self.
		compilerObjectType := SYMLCompilerObjectType new target: self.
		
		literalIntegerType := SYMLLiteralIntegerType new target: self.
		literalFloatType := SYMLLiteralFloatType new target: self.
		literalBooleanType := SYMLLiteralBooleanType new target: self.
		literalCharacterType := SYMLLiteralCharacterType new target: self.
		literalStringType := SYMLLiteralStringType new target: self.
		literalSymbolType := SYMLLiteralSymbolType new target: self.
		literalArrayType := SYMLLiteralArrayType new target: self.
	}	

]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> int16Type [
	^ int16Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> int32Type [
	^ int32Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> int64Type [
	^ int64Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> int8Type [
	^ int8Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalArrayType [
	^ literalArrayType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalBooleanType [
	^ literalBooleanType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalCharacterType [
	^ literalCharacterType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalFloatType [
	^ literalFloatType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalIntegerType [
	^ literalIntegerType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalStringType [
	^ literalStringType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> literalSymbolType [
	^ literalSymbolType
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> lowLevelTarget [
	^ lowLevelTarget
]

{ #category : #'composite types' }
SYMLSLVMCompilationTarget >> metaTypeFor: aType [
	^ metaTypes at: aType ifAbsentPut: [ SYMLMetaType new target: self; instanceType: aType; yourself ]
]

{ #category : #flags }
SYMLSLVMCompilationTarget >> pic [
	lowLevelTarget pic
]

{ #category : #flags }
SYMLSLVMCompilationTarget >> pie [
	lowLevelTarget pie
]

{ #category : #'composite types' }
SYMLSLVMCompilationTarget >> pointerTo: pointedType [
	^ pointerTypes at: pointedType ifAbsentPut: [
		SYMLPointerType new
			target: self;
			pointed: pointedType;
			yourself
	]
]

{ #category : #'composite types' }
SYMLSLVMCompilationTarget >> referenceTo: referencedType [
	^ referenceTypes at: referencedType ifAbsentPut: [
		SYMLReferenceType new
			target: self;
			referenced: referencedType;
			yourself
	]
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> tuple: types [
	| tuple |
	tuple := SYMLTupleType new
		target: self;
		types: types;
		yourself.
	^ tupleTypes at: tuple ifAbsentPut: [ tuple ]
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> uint16Type [
	^ uint16Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> uint32Type [
	^ uint32Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> uint64Type [
	^ uint64Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> uint8Type [
	^ uint8Type
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> voidType [
	^ voidType
]

{ #category : #'composite types' }
SYMLSLVMCompilationTarget >> volatileType: valueType [
	valueType isVolatile ifTrue: [ ^ valueType ].
	^ volatileTypes at: valueType ifAbsentPut: [ SYMLVolatileType new target: self; decorated: valueType ]
]
