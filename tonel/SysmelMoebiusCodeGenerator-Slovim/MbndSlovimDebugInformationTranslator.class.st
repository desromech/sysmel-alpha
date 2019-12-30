Class {
	#name : #MbndSlovimDebugInformationTranslator,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'translatedEntities',
		'codeModuleGenerator'
	],
	#classVars : [
		'DebugDecorationWhiteList'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimDebugInformationTranslator class >> initialize [
	DebugDecorationWhiteList := Set newFrom: #(
		const volatile restrict
	)
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> addAggregateDebugType: debugType fieldMember: field into: out [ 
	| member |
	field name isMbndAnonymousSymbol ifTrue: [ ^ self ].
	
	member := SLVMDebugDerivedType new
		makeMember;
		name: field name;
		baseType: (self translateDebugType: field valueType);
		byteSize: field valueType instanceSize;
		byteOffset: field byteOffset.
		
	field bits ifNotNil: [
		member
			isBitField: true;
			bitSize: field bits;
			"bitOffset: (field byteOffset * 8) + (field valueType instanceSize * 8) - field bitOffset - field bits"
			bitOffset: (field byteOffset * 8) + field bitOffset
	].
		
	out nextPut: member

]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> addAggregateDebugType: debugType membersFrom: aggregateType [
	debugType members: ((Array streamContents: [ :out |
		aggregateType supertype isTrait ifFalse: [
			out nextPut: (SLVMDebugDerivedType new
				makeInheritance;
				baseType: (self translateSuperDebugType: aggregateType supertype);
				byteOffset: 0
			)
		].
	
		aggregateType fields do: [ :field |
			self addAggregateDebugType: debugType fieldMember: field into: out 
		]
	]) sorted: [ :a :b | a bitOffset < b bitOffset ])
]

{ #category : #initialization }
MbndSlovimDebugInformationTranslator >> initialize [
	super initialize.
	translatedEntities := Dictionary new.
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> setCommonDebugSubprogram: debugSubprogram informationFrom: method [
	method parent ifNotNil: [ 
		debugSubprogram parentScope: (self translateParentScope: method parent)
	].

	debugSubprogram
		isLocal: method hasPublicOrExternalVisibility not;
		isDefinition: method isDefinition;
		type: (self translateDebugType: method type)
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> setCommonDebugType: debugType informationFrom: typeEntity [
	typeEntity name isMbndAnonymousSymbol ifFalse: [ 
		debugType name: typeEntity name
	].

	(typeEntity isMetaType and: [ typeEntity instanceType isNotNil ]) ifTrue: [ 
		self assert: typeEntity name isMbndAnonymousSymbol.
		debugType
			name: '__Type__';
			parentScope: (self translateSuperDebugType: typeEntity instanceType)
	] ifFalse: [
		typeEntity parent ifNotNil: [ 
			debugType parentScope: (self translateParentScope: typeEntity parent)
		].
	]

]

{ #category : #'code generation' }
MbndSlovimDebugInformationTranslator >> translateDebugType: aType [
	^ self translateProgramEntityDebugInformation: aType
]

{ #category : #'as yet unclassified' }
MbndSlovimDebugInformationTranslator >> translateLexicalScope: lexicalScope [
	| translatedScope |
	lexicalScope ifNil: [ ^ nil ].

	translatedEntities at: lexicalScope ifPresent: [ :existent | ^ existent ].
	
	lexicalScope isProgramEntityScope ifTrue: [
		lexicalScope programEntity isBlockClosureWithImmediateActivation ifFalse: [ 
			translatedScope := self translateParentScope: lexicalScope programEntity.
			translatedEntities at: lexicalScope put: translatedScope.
			^ translatedScope.
		].
	].

	translatedScope := SLVMDebugLexicalScope new.
	translatedEntities at: lexicalScope put: translatedScope.
	translatedScope parentScope: (self translateLexicalScope: lexicalScope parent).
	
	lexicalScope definitionPosition ifNotNil: [ :scopePositionNode |
		| scopePosition |
		scopePosition := scopePositionNode asActualSourcePosition.
		translatedScope
			file: (codeModuleGenerator convertDebugSourceFile: scopePosition collection);
			startLine: scopePosition line;
			startColumn: scopePosition column;
			endLine: scopePosition endLine;
			endColumn: scopePosition endColumn
	].
	^ translatedScope
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> translateParentScope: parentScope [
	| debugScope |
	debugScope := self translateProgramEntityDebugInformation: parentScope.
	parentScope isMbndType ifTrue: [ 
		parentScope isGCClassType ifTrue: [ 
			self assert: debugScope isDebugDerivedType.
			^ debugScope baseType.
		].
	].
	^ debugScope

]

{ #category : #'code generation' }
MbndSlovimDebugInformationTranslator >> translateProgramEntityDebugInformation: aProgramEntity [
	^ translatedEntities at: aProgramEntity ifAbsentPut: [ aProgramEntity accept: self ]

]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> translateSuperDebugType: supertype [
	| debugType |
	debugType := self translateDebugType: supertype.
	debugType isDebugDerivedType ifTrue: [ ^ debugType baseType ].
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitAggregateBasicInitializeMethod: method [
	^ self visitConcreteMessageMethod: method
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitAggregateFinalizeMethod: method [
	^ self visitConcreteMessageMethod: method
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitAggregateInitializeFromCopyMethod: method [
	^ self visitConcreteMessageMethod: method
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitAggregateInitializeMethod: method [
	^ self visitConcreteMessageMethod: method
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitAggregateInitializeMovingFromMethod: method [
	^ self visitConcreteMessageMethod: method
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitArrayType: arrayType [
	| debugType |
	arrayType isTrait ifTrue: [ ^ self visitTraitType: arrayType ].
	
	debugType := SLVMDebugCompositeType new makeArray.
	translatedEntities at: arrayType put: debugType.
	debugType
		byteSize: arrayType instanceSize;
		byteAlignment: arrayType instanceAlignment;
		arrayRange: (arrayType elements ifNil: [0]);
		baseType: (self translateDebugType: arrayType elementType).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitBlockClosureMethod: blockClosureMethod [
	self deny: blockClosureMethod isBlockClosureWithImmediateActivation.
	self halt
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitClassType: classType [
	| debugType |
	classType isTrait ifTrue: [ ^ self visitTraitType: classType ].
	
	debugType := SLVMDebugCompositeType new makeClass.
	translatedEntities at: classType put: debugType.
	self setCommonDebugType: debugType informationFrom: classType.
	debugType
		byteSize: classType instanceSize;
		byteAlignment: classType instanceAlignment.

	self addAggregateDebugType: debugType membersFrom: classType.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitCompileTimeVariable: compileTimeVariable [
	self flag: 'TODO: Translate myself properly'.
	^ (SLVMDebugVariable scope: nil name: compileTimeVariable name asPrettySymbolName)
		type: (self translateDebugType: compileTimeVariable valueType);
		yourself.
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitConcreteFunctionMethod: method [
	| debugInfo |
	debugInfo := SLVMDebugSubprogram new.
	method name isMbndAnonymousSymbol ifFalse: [ 
		debugInfo
			name: method name;
			emitLinkageName: true
	].

	translatedEntities at: method put: debugInfo.
	self setCommonDebugSubprogram: debugInfo informationFrom: method.
	^ debugInfo
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitConcreteMessageMethod: method [
	| debugInfo |
	debugInfo := SLVMDebugSubprogram new.
	method name isMbndAnonymousSymbol ifFalse: [ 
		debugInfo
			name: '[', method name , ']';
			emitLinkageName: true
	].

	translatedEntities at: method put: debugInfo.
	self setCommonDebugSubprogram: debugInfo informationFrom: method.
	^ debugInfo
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitDecoratedType: type [
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
	translatedEntities at: type put: baseType.
	^ baseType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitEnumType: enumType [
	| debugType |
	enumType isTrait ifTrue: [ ^ self visitTraitType: enumType ].
	
	debugType := SLVMDebugCompositeType new makeEnumeration.
	translatedEntities at: enumType put: debugType.
	self setCommonDebugType: debugType informationFrom: enumType.
	
	debugType
		baseType: (self translateDebugType: enumType valueType);
		byteSize: enumType instanceSize;
		byteAlignment: enumType instanceAlignment.

	self flag: 'TODO: Add the numeration members.'.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitFunctionArgumentVariable: argumentVariable [
	^ (SLVMDebugVariable scope: nil name: argumentVariable name asPrettySymbolName)
		type: (self translateDebugType: argumentVariable valueType);
		argumentIndex: argumentVariable argumentIndex;
		yourself.
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitFunctionLocalVariable: localVariable [
	| scope |
	scope := self translateLexicalScope: localVariable definitionScope.
	^ (SLVMDebugVariable scope: scope name: localVariable name asPrettySymbolName)
		type: (self translateDebugType: localVariable valueType);
		yourself.
	
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitFunctionReceiverArgumentVariable: argumentVariable [
	^ self visitFunctionArgumentVariable: argumentVariable
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitFunctionType: functionType [
	| subroutineType |
	functionType isTrait ifTrue: [ ^ self visitTraitType: functionType ].
	
	subroutineType := SLVMDebugSubroutineType new.
	translatedEntities at: functionType put: subroutineType.
	
	subroutineType
		argumentTypes: (functionType argumentTypes collect: [:arg | self translateDebugType: (arg asConcreteTypeForAnalysisOfFunctionType: functionType)]);
		returnType: (self translateDebugType: (functionType returnType asConcreteTypeForAnalysisOfFunctionType: functionType) );
		yourself.
	^ subroutineType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitGCClassType: classType [
	| debugType gcClassPointerType |
	classType isTrait ifTrue: [ ^ self visitTraitType: classType ].
	
	debugType := SLVMDebugCompositeType new makeClass.
	gcClassPointerType := SLVMDebugDerivedType new makePointer
		baseType: debugType;
		byteSize: self compilationTarget pointerSize;
		byteAlignment: self compilationTarget pointerAlignment.
	translatedEntities at: classType put: gcClassPointerType.
	self setCommonDebugType: debugType informationFrom: classType.
	debugType
		byteSize: classType instanceDataSize;
		byteAlignment: classType instanceDataAlignment.

	self addAggregateDebugType: debugType membersFrom: classType.
	
	^ gcClassPointerType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitGCClassVariableDataArrayType: arrayType [
	| debugType |
	arrayType isTrait ifTrue: [ ^ self visitTraitType: arrayType ].
	
	debugType := SLVMDebugCompositeType new makeArray.
	translatedEntities at: arrayType put: debugType.
	debugType
		byteSize: arrayType instanceSize;
		byteAlignment: arrayType instanceAlignment;
		arrayRange: 0;
		baseType: (self translateDebugType: arrayType elementType).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitGlobalVariable: globalVariable [
	self flag: 'TODO: Translate myself properly'.
	^ (SLVMDebugVariable scope: nil name: globalVariable name asPrettySymbolName)
		type: (self translateDebugType: globalVariable valueType);
		yourself.
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitNamespace: namespace [
	| debugInformation |
	(namespace name = #__global and: [ namespace parent isNil ]) ifTrue: [ 
		^ nil
	].

	debugInformation := SLVMDebugNamespace new name: namespace name.
	translatedEntities at: namespace put: debugInformation.
	^ debugInformation
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitPointerType: pointerType [
	| derivedType |
	pointerType isTrait ifTrue: [ ^ self visitTraitType: pointerType ].
	
	derivedType := SLVMDebugDerivedType new makePointer.
	translatedEntities at: pointerType put: derivedType.
	derivedType
		baseType: (self translateDebugType: pointerType baseType);
		byteSize: pointerType instanceSize;
		byteAlignment: pointerType instanceAlignment.
	^ derivedType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitPrimitiveBooleanType: type [
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
MbndSlovimDebugInformationTranslator >> visitPrimitiveCharacterCodeType: type [
	| basicType |
	type isTrait ifTrue: [ self visitTraitType: type ].
	basicType := SLVMDebugBasicType new.
	basicType
		byteSize: type instanceSize;
		byteAlignment: type instanceAlignment;
		makeCharacter.
	self setCommonDebugType: basicType informationFrom: type.
	^ basicType.
	
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitPrimitiveFloatType: type [
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
MbndSlovimDebugInformationTranslator >> visitPrimitiveIntegerType: type [
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
MbndSlovimDebugInformationTranslator >> visitPrimitiveMatrixType: matrixType [
	| debugType |
	matrixType isTrait ifTrue: [ ^ self visitTraitType: matrixType ].
	
	debugType := SLVMDebugCompositeType new makeArray.
	translatedEntities at: matrixType put: debugType.
	self setCommonDebugType: debugType informationFrom: matrixType.
	
	debugType
		byteSize: matrixType instanceSize;
		byteAlignment: matrixType instanceAlignment;
		arrayRange: matrixType columns;
		baseType: (self translateDebugType: matrixType columnType).
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitPrimitiveVectorType: vectorType [
	| debugType elementType elementDebugType |
	vectorType isTrait ifTrue: [ ^ self visitTraitType: vectorType ].
	
	debugType := SLVMDebugCompositeType new makeStructure.
	translatedEntities at: vectorType put: debugType.
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
MbndSlovimDebugInformationTranslator >> visitReferenceType: referenceType [
	| derivedType |
	referenceType isTrait ifTrue: [ ^ self visitTraitType: referenceType ].
	derivedType := SLVMDebugDerivedType new makeReference.
	translatedEntities at: referenceType put: derivedType.
	derivedType
		baseType: (self translateDebugType: referenceType baseType);
		byteSize: referenceType instanceSize;
		byteAlignment: referenceType instanceAlignment.
	^ derivedType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitSimpleMetaType: simpleMetaType [
	| debugStructureType debugType |
	simpleMetaType isTrait ifTrue: [ ^ self visitTraitType: simpleMetaType ].
	
	debugStructureType := SLVMDebugCompositeType new makeStructure.
	debugType := SLVMDebugDerivedType new
		makePointer;
		baseType: debugStructureType;
		byteSize: self compilationTarget pointerSize;
		byteAlignment: self compilationTarget pointerAlignment.
	self setCommonDebugType: debugStructureType informationFrom: simpleMetaType.
	translatedEntities at: simpleMetaType put: debugType.
	self flag: 'TODO: Add the member fields.'.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitStructureType: structureType [
	| debugType |
	structureType isTrait ifTrue: [ ^ self visitTraitType: structureType ].
	
	debugType := SLVMDebugCompositeType new makeStructure.
	translatedEntities at: structureType put: debugType.
	self setCommonDebugType: debugType informationFrom: structureType.
	
	debugType
		byteSize: structureType instanceSize;
		byteAlignment: structureType instanceAlignment.

	self addAggregateDebugType: debugType membersFrom: structureType.
	
	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitTemplateInstance: templateInstance [
	self flag: 'TODO: Support this case.'.
	^ nil
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitTemporaryReferenceType: referenceType [
	| derivedType |
	referenceType isTrait ifTrue: [ ^ self visitTraitType: referenceType ].
	derivedType := SLVMDebugDerivedType new makeTemporaryReference.
	translatedEntities at: referenceType put: derivedType.
	derivedType
		baseType: (self translateDebugType: referenceType baseType);
		byteSize: referenceType instanceSize;
		byteAlignment: referenceType instanceAlignment.
	^ derivedType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitUnionType: unionType [
	| debugType |
	unionType isTrait ifTrue: [ ^ self visitTraitType: unionType ].
	
	debugType := SLVMDebugCompositeType new makeUnion.
	translatedEntities at: unionType put: debugType.
	self setCommonDebugType: debugType informationFrom: unionType.
	
	debugType
		byteSize: unionType instanceSize;
		byteAlignment: unionType instanceAlignment.
		
	self addAggregateDebugType: debugType membersFrom: unionType.

	^ debugType
]

{ #category : #visiting }
MbndSlovimDebugInformationTranslator >> visitVoidType: type [
	^ SLVMDebugBasicType new
		makeVoid;
		yourself.
]
