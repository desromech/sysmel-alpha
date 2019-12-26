Class {
	#name : #MbndSlovimDebugTypeTranslator,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'translatedTypes'
	],
	#classVars : [
		'DebugDecorationWhiteList'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimDebugTypeTranslator class >> initialize [
	DebugDecorationWhiteList := Set newFrom: #(
		const volatile restrict
	)
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> addAggregateDebugType: debugType membersFrom: aggregateType [
	debugType members: (Array streamContents: [ :out |
		aggregateType fields do: [ :field |
			field name isMbndAnonymousSymbol ifFalse: [
				out nextPut: (SLVMDebugDerivedType new makeMember;
					name: field name;
					baseType: (self translateDebugType: field valueType);
					byteSize: field valueType instanceSize;
					byteOffset: field byteOffset
				)
			].
		]
	])

]

{ #category : #initialization }
MbndSlovimDebugTypeTranslator >> initialize [
	super initialize.
	translatedTypes := Dictionary new.
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> setCommonDebugType: debugType informationFrom: typeEntity [
	typeEntity name isMbndAnonymousSymbol ifFalse: [ 
		debugType name: typeEntity name
	].

]

{ #category : #'code generation' }
MbndSlovimDebugTypeTranslator >> translateDebugType: aType [
	^ translatedTypes at: aType ifAbsentPut: [ aType accept: self ]

]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitArrayType: arrayType [
	| debugType |
	arrayType isTrait ifTrue: [ ^ self visitTraitType: arrayType ].
	
	debugType := SLVMDebugCompositeType new makeArray.
	translatedTypes at: arrayType put: debugType.
	debugType
		byteSize: arrayType instanceSize;
		byteAlignment: arrayType instanceAlignment;
		arrayRange: (arrayType elements ifNil: [0]);
		baseType: (self translateDebugType: arrayType elementType).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitClassType: classType [
	| debugType |
	classType isTrait ifTrue: [ ^ self visitTraitType: classType ].
	
	debugType := SLVMDebugCompositeType new makeClass.
	translatedTypes at: classType put: debugType.
	self setCommonDebugType: debugType informationFrom: classType.
	debugType
		byteSize: classType instanceSize;
		byteAlignment: classType instanceAlignment.

	self addAggregateDebugType: debugType membersFrom: classType.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitDecoratedType: type [
	| baseType |
	type isTrait ifTrue: [ ^ self visitTraitType: type ].
	
	baseType := self translateDebugType: type baseType.
	type decorations do: [ :decoration |
		(DebugDecorationWhiteList includes: decoration) ifTrue: [ 
			| derivedType |
			derivedType := SLVMDebugDerivedType new
				kind: decoration;
				baseType: baseType.
			baseType := derivedType.
		].
	].
	translatedTypes at: type put: baseType.
	^ baseType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitEnumType: enumType [
	| debugType |
	enumType isTrait ifTrue: [ ^ self visitTraitType: enumType ].
	
	debugType := SLVMDebugCompositeType new makeEnumeration.
	translatedTypes at: enumType put: debugType.
	self setCommonDebugType: debugType informationFrom: enumType.
	
	debugType
		baseType: (self translateDebugType: enumType valueType);
		byteSize: enumType instanceSize;
		byteAlignment: enumType instanceAlignment.

	self flag: 'TODO: Add the numeration members.'.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitFunctionType: functionType [
	| subroutineType |
	functionType isTrait ifTrue: [ ^ self visitTraitType: functionType ].
	
	subroutineType := SLVMDebugSubroutineType new.
	translatedTypes at: functionType put: subroutineType.
	
	subroutineType
		argumentTypes: (functionType argumentTypes collect: [:arg | self translateDebugType: (arg asConcreteTypeForAnalysisOfFunctionType: functionType)]);
		returnType: (self translateDebugType: (functionType returnType asConcreteTypeForAnalysisOfFunctionType: functionType) );
		yourself.
	^ subroutineType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitGCClassType: classType [
	| debugType gcClassPointerType |
	classType isTrait ifTrue: [ ^ self visitTraitType: classType ].
	
	debugType := SLVMDebugCompositeType new makeClass.
	gcClassPointerType := SLVMDebugDerivedType new makePointer
		baseType: debugType;
		byteSize: self compilationTarget pointerSize;
		byteAlignment: self compilationTarget pointerAlignment.
	translatedTypes at: classType put: gcClassPointerType.
	self setCommonDebugType: debugType informationFrom: classType.
	debugType
		byteSize: classType instanceSize;
		byteAlignment: classType instanceAlignment.

	self addAggregateDebugType: debugType membersFrom: classType.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitGCClassVariableDataArrayType: arrayType [
	| debugType |
	arrayType isTrait ifTrue: [ ^ self visitTraitType: arrayType ].
	
	debugType := SLVMDebugCompositeType new makeArray.
	translatedTypes at: arrayType put: debugType.
	debugType
		byteSize: arrayType instanceSize;
		byteAlignment: arrayType instanceAlignment;
		arrayRange: 0;
		baseType: (self translateDebugType: arrayType elementType).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitPointerType: pointerType [
	| derivedType |
	pointerType isTrait ifTrue: [ ^ self visitTraitType: pointerType ].
	
	derivedType := SLVMDebugDerivedType new makePointer.
	translatedTypes at: pointerType put: derivedType.
	derivedType
		baseType: (self translateDebugType: pointerType baseType);
		byteSize: pointerType instanceSize;
		byteAlignment: pointerType instanceAlignment.
	^ derivedType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitPrimitiveBooleanType: type [
	| basicType |
	type isTrait ifTrue: [ self visitTraitType: type ].
	basicType := SLVMDebugBasicType new
		makeBoolean;
		byteSize: type instanceSize;
		byteAlignment: type instanceAlignment;
		yourself.
	self setCommonDebugType: basicType informationFrom: type.
	^ basicType.
	
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitPrimitiveFloatType: type [
	| basicType |
	type isTrait ifTrue: [ self visitTraitType: type ].
	basicType := SLVMDebugBasicType new
		makeFloat;
		byteSize: type instanceSize;
		byteAlignment: type instanceAlignment;
		yourself.
	self setCommonDebugType: basicType informationFrom: type.
	^ basicType.
	
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitPrimitiveIntegerType: type [
	| basicType |
	type isTrait ifTrue: [ self visitTraitType: type ].
	basicType := SLVMDebugBasicType new.
	basicType
		byteSize: type instanceSize;
		byteAlignment: type instanceAlignment.
	type isSigned
		ifTrue: [ basicType makeSignedInteger ]
		ifFalse: [ basicType makeUnsignedInteger ].
	self setCommonDebugType: basicType informationFrom: type.
	^ basicType.
	
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitPrimitiveMatrixType: matrixType [
	| debugType |
	matrixType isTrait ifTrue: [ ^ self visitTraitType: matrixType ].
	
	debugType := SLVMDebugCompositeType new makeArray.
	translatedTypes at: matrixType put: debugType.
	self setCommonDebugType: debugType informationFrom: matrixType.
	
	debugType
		byteSize: matrixType instanceSize;
		byteAlignment: matrixType instanceAlignment;
		arrayRange: matrixType columns;
		baseType: (self translateDebugType: matrixType columnType).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitPrimitiveVectorType: vectorType [
	| debugType elementType elementDebugType |
	vectorType isTrait ifTrue: [ ^ self visitTraitType: vectorType ].
	
	debugType := SLVMDebugCompositeType new makeStructure.
	translatedTypes at: vectorType put: debugType.
	self setCommonDebugType: debugType informationFrom: vectorType.
	
	elementType := vectorType elementType.
	elementDebugType := self translateDebugType: elementType.
	debugType
		byteSize: vectorType instanceSize;
		byteAlignment: vectorType instanceAlignment;
		members: ((1 to: (vectorType elements min: 4)) collect: [ :i |
			(SLVMDebugDerivedType new makeMember;
					name: ('xyzw' at: i) asString;
					baseType: elementDebugType;
					byteSize: elementType instanceSize;
					byteOffset: elementType instanceSize * (i - 1)
				)
		]).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitReferenceType: referenceType [
	| derivedType |
	referenceType isTrait ifTrue: [ ^ self visitTraitType: referenceType ].
	derivedType := SLVMDebugDerivedType new makeReference.
	translatedTypes at: referenceType put: derivedType.
	derivedType
		baseType: (self translateDebugType: referenceType baseType);
		byteSize: referenceType instanceSize;
		byteAlignment: referenceType instanceAlignment.
	^ derivedType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitSimpleMetaType: simpleMetaType [
	| debugStructureType debugType |
	simpleMetaType isTrait ifTrue: [ ^ self visitTraitType: simpleMetaType ].
	
	debugStructureType := SLVMDebugCompositeType new makeStructure.
	debugType := SLVMDebugDerivedType new
		makePointer;
		baseType: debugStructureType;
		byteSize: self compilationTarget pointerSize;
		byteAlignment: self compilationTarget pointerAlignment.
	self setCommonDebugType: debugStructureType informationFrom: simpleMetaType.
	translatedTypes at: simpleMetaType put: debugType.
	self flag: 'TODO: Add the member fields.'.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitStructureType: structureType [
	| debugType |
	structureType isTrait ifTrue: [ ^ self visitTraitType: structureType ].
	
	debugType := SLVMDebugCompositeType new makeStructure.
	translatedTypes at: structureType put: debugType.
	self setCommonDebugType: debugType informationFrom: structureType.
	
	debugType
		byteSize: structureType instanceSize;
		byteAlignment: structureType instanceAlignment.

	self addAggregateDebugType: debugType membersFrom: structureType.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitUnionType: unionType [
	| debugType |
	unionType isTrait ifTrue: [ ^ self visitTraitType: unionType ].
	
	debugType := SLVMDebugCompositeType new makeUnion.
	translatedTypes at: unionType put: debugType.
	self setCommonDebugType: debugType informationFrom: unionType.
	
	debugType
		byteSize: unionType instanceSize;
		byteAlignment: unionType instanceAlignment.
		
	self addAggregateDebugType: debugType membersFrom: unionType.

	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugTypeTranslator >> visitVoidType: type [
	^ SLVMDebugBasicType new
		makeVoid;
		yourself.
]
