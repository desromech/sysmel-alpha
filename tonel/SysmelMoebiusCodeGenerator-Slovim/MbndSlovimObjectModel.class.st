Class {
	#name : #MbndSlovimObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'managedObjectModel',
		'moduleCodeGenerator',
		'gcrootIntrinsic',
		'messageLookupFunction',
		'convertedLiteralContent',
		'convertedLiteralGlobals',
		'superMessageLookupFunction',
		'trueLiteralValue',
		'falseLiteralValue',
		'uint32ToIntegerFunction',
		'uint64ToIntegerFunction',
		'int64ToIntegerFunction',
		'int32ToIntegerFunction',
		'uint32ToCharacterFunction',
		'float64ToFloatFunction',
		'nativeClosureHeaderType',
		'gcClosureHeaderType',
		'gcBlockClosureAllocationFunction',
		'gcBlockClosureHeaderConstant',
		'gcBlockClosureHeaderNumArgsSlotIndex',
		'gcBlockClosureHeaderDynamicCallAdapterSlotIndex',
		'dynamicObjectType',
		'objectToUInt32Function',
		'objectToInt32Function',
		'objectToUInt64Function',
		'objectToInt64Function',
		'objectToChar32Function',
		'objectToFloat64Function',
		'objectToBoolean8Function',
		'moduleRootRegistrationFunction',
		'receiverClassGetter',
		'methodSuperClassGetter',
		'inlineCacheStructure',
		'gcShadowStackEnterFunction',
		'gcShadowStackLeaveFunction',
		'gcShadowStackRecordStructure',
		'gcShadowStackRootCountField',
		'gcShadowStackRootsField',
		'gcSafePointFunction',
		'gcShadowStackLandingPadFunction',
		'simpleGCBlockClosureDynamicCaptureCountSlotIndex',
		'functionContextMetadata'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #accessing }
MbndSlovimObjectModel >> arrayClass [
	^ managedObjectModel arrayClass
]

{ #category : #accessing }
MbndSlovimObjectModel >> associationClass [
	^ managedObjectModel associationClass
]

{ #category : #accessing }
MbndSlovimObjectModel >> associationValueOffset [
	^ managedObjectModel associationValueOffset
]

{ #category : #accessing }
MbndSlovimObjectModel >> byteArrayClass [
	^ managedObjectModel byteArrayClass
]

{ #category : #accessing }
MbndSlovimObjectModel >> classVariableClass [
	^ managedObjectModel classVariableClass
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> closureHeaderTypeForKind: kind [
	kind == #nativeStack ifTrue: [ 
		^ self nativeClosureHeaderType
	].

	kind == #gc ifTrue: [
		^ self gcClosureHeaderType
	].

	self error: 'Unsupported closure header type.'

]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> compiledMethodLiteralsOffset [
	^ managedObjectModel compiledMethodClass instanceDataSize alignedTo: managedObjectModel compiledMethodClass instanceDataAlignment
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> constructClosurePrototypeFor: closureDefinition [
	| prototype mbndFunctionType header dynamicCallAdapterSlotIndex numArgsSlotIndex dynamicCallAdapter capturedTypes closureTypeInfo |
	prototype := super constructClosurePrototypeFor: closureDefinition.
	mbndFunctionType := closureDefinition propertyAt: #mbndFunctionType.
	capturedTypes := closureDefinition captures collect: [ :each | each propertyAt: #mbndType ].
	closureDefinition kind = #nativeStack ifTrue: [
		closureTypeInfo := moduleCodeGenerator getOrCreateNativeClosureTypeInfoFor: mbndFunctionType withCaptures: capturedTypes for: prototype.
		closureTypeInfo ifNotNil: [
			prototype slots at: 1 put: closureTypeInfo
		].
	].

	closureDefinition kind = #gc ifTrue: [
		self assert: mbndFunctionType canHaveDynamicMethodWrapper.
		dynamicCallAdapter := moduleCodeGenerator getOrCreateDynamicFunctionCallAdapterFor: mbndFunctionType.
		dynamicCallAdapterSlotIndex := self gcBlockClosureHeaderDynamicCallAdapterSlotIndex + 1.
		numArgsSlotIndex := self gcBlockClosureHeaderNumArgsSlotIndex + 1.

		header := self gcBlockClosureHeaderConstant copy.
		(capturedTypes anySatisfy: [:each | each hasGarbageCollectedAddressSpace not and: [each isPOD not ]]) ifTrue: [
			self halt
		] ifFalse: [
			| dynamicCaptureCount |
			dynamicCaptureCount := 0.
			capturedTypes do: [ :each |
				each hasGarbageCollectedAddressSpace ifTrue: [ 
					each isArrayType ifTrue: [
						dynamicCaptureCount := dynamicCaptureCount + each elements.
					] ifFalse: [ 
						dynamicCaptureCount := dynamicCaptureCount + 1
					]
				]
			].
			header slots at: simpleGCBlockClosureDynamicCaptureCountSlotIndex + 1 put:
				((header slots at: simpleGCBlockClosureDynamicCaptureCountSlotIndex + 1) copy value: dynamicCaptureCount)
		].

		header slots
			at: dynamicCallAdapterSlotIndex put: (
				SLVMConstant pointer: dynamicCallAdapter castTo: (header slots at: dynamicCallAdapterSlotIndex) type
			);
			at: numArgsSlotIndex put:
			((header slots at: numArgsSlotIndex) copy
				value: mbndFunctionType argumentTypes size - "closure pointer" 1).
		prototype slots at: 1 put: header.
	].

	^ prototype
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> convertDynamicLiteralToConstant: dynamicLiteralValue [
	^ self convertDynamicLiteralToConstant: dynamicLiteralValue withName: nil
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> convertDynamicLiteralToConstant: dynamicLiteralValue withName: dynamicLiteralName [
	| initialValue targetType convertedValue literalGlobal |
	dynamicLiteralValue isMbndProgramEntity ifTrue: [
		^ (moduleCodeGenerator translateProgramEntity: dynamicLiteralValue) ssaValue
	].
	(self isInlineLiteral: dynamicLiteralValue) ifTrue: [
		^ self convertInlineLiteral: dynamicLiteralValue
	].

	convertedLiteralGlobals at: dynamicLiteralValue ifPresent: [ :previousVersion | ^ previousVersion ].
	targetType := moduleCodeGenerator translateType: moduleCodeGenerator compilationTarget dynamicObjectType.
	convertedValue := SLVMConstantExpresionBitCast new value: nil targetType: targetType.
	convertedLiteralGlobals at: dynamicLiteralValue put: convertedValue.

	initialValue := moduleCodeGenerator translateDynamicObjectInstanceContent: (dynamicLiteralValue isMbndAbstractValue ifTrue: [ 
		self assert: dynamicLiteralValue isAggregateTypeInstanceValue.
		dynamicLiteralValue
	] ifFalse: [
		dynamicLiteralValue createNonInlineLiteralObjectForMbndObjectModel: self .
	]).

	literalGlobal := SLVMGlobalVariable module: moduleCodeGenerator ssaModule name: dynamicLiteralName valueType: initialValue type storage: SLVMType gcStorage.
	literalGlobal
		makePrivate;
		omitDebugInformation: true;
		initialValue: initialValue.
	
	convertedValue value: literalGlobal targetType: targetType.
	^ convertedValue
]

{ #category : #converting }
MbndSlovimObjectModel >> convertInlineLiteral: literalValue withType: targetType [
	^ SLVMConstantValue type: targetType value: literalValue
]

{ #category : #converting }
MbndSlovimObjectModel >> createArray: array class: arrayClass [
	| result |
	result := arrayClass makeInstance: array size identityHash: self generateIdentityHash.
	result slots last slots: (array collect: [:el | self convertDynamicLiteralToConstant: el ]).
	^ result
]

{ #category : #converting }
MbndSlovimObjectModel >> createAssociation: association class: associationClass [
	| result |
	result := associationClass makeInstance: 0 identityHash: self generateIdentityHash.
	result
		setField: #key value: (self convertDynamicLiteralToConstant: association key);
		setField: #value value: (self convertDynamicLiteralToConstant: association value).
	^ result
]

{ #category : #converting }
MbndSlovimObjectModel >> createBoxedFloatInstance: aFloat [
	^ convertedLiteralContent at: aFloat ifAbsentPut: [
		| data instance |
		data := aFloat asFloat.
		instance := managedObjectModel boxedFloat64Class makeInstance: 0 identityHash: data hash.
		instance setField: #__float64Value value: data.
		instance
	]

]

{ #category : #'code generation' }
MbndSlovimObjectModel >> createDoesNotUnderstandTrampolineWithType: functionType [
	| function builder boxedMessage result convertedResult |
	self halt.
	function := SLVMFunction pointerSize: target pointerSize functionType: functionType.
	function
		compilationTarget: target;
		propertyAt: #omitDebugInformation put: true;
		propertyAt: #dnuTrampoline put: true;
		gcStrategy: #sysmel.
	
	
	builder := SLVMBuilder on: function.
	
	builder newBasicBlockHere: #entry.
	
	boxedMessage := builder addDynamicLiteral: nil.
	
	result := builder send: (builder addDynamicLiteral: #doesNotUnderstand:)
		returnType: target dynamicObjectType 
		receiver: function arguments first
		arguments: { boxedMessage }.
	
	functionType returnType isDynamicObjectType ifTrue: [ 
		convertedResult := result type == functionType returnType
			ifTrue: [ result ]
			ifFalse: [ builder bitCast: result target: functionType returnType ].
		builder return: convertedResult.
	] ifFalse: [ 
		functionType returnType isVoidType ifTrue: [
			builder returnVoid
		] ifFalse: [ 
			self flag: 'TODO: Unbox the result.'.
			builder return: functionType returnType defaultConstant
		].
	].

	^ function
]

{ #category : #visiting }
MbndSlovimObjectModel >> createFunctionContextMetaData: aFunction [
	^ functionContextMetadata at: aFunction ifAbsentPut: [ 
		| literals compiledMethod literalSymbol |
		literals := aFunction dynamicLiterals.
		compiledMethod := managedObjectModel compiledMethodClass makeInstance: literals size identityHash: 0.

		compiledMethod setField: #entryPoint value: aFunction.
		compiledMethod slots last slots: (literals collect: [:each | each value] as: Array).
		literalSymbol := aFunction name , '..compiledMethod..'.
		self convertDynamicLiteralToConstant: compiledMethod withName: literalSymbol.
		compiledMethod
	].


]

{ #category : #'code generation' }
MbndSlovimObjectModel >> createNativeMethodDispatchTrampolineWithType: functionType [
	self assert: functionType isMbndType.
	^ moduleCodeGenerator getOrCreateNativeMethodDispatchTrampolineWithType: functionType
]

{ #category : #converting }
MbndSlovimObjectModel >> createNonInlineLiteralConstant: aLiteral withCodeGenerator: aCodeGenerator [
	^ moduleCodeGenerator translateDynamicObjectInstanceContent:( aLiteral createNonInlineLiteralObjectForMbndObjectModel: self)
]

{ #category : #converting }
MbndSlovimObjectModel >> createNonInlineLiteralUniqueGlobal: aLiteral withCodeGenerator: codeGenerator [
	^ self convertDynamicLiteralToConstant: aLiteral
	"aLiteral isMbndProgramEntity ifTrue: [
		^ (moduleCodeGenerator translateProgramEntity: aLiteral) ssaValue
	].
	^ nil"
]

{ #category : #converting }
MbndSlovimObjectModel >> createObjectBytes: bytes class: class [
	^ self createObjectBytes: bytes class: class identityHash: self generateIdentityHash
]

{ #category : #converting }
MbndSlovimObjectModel >> createObjectBytes: bytes class: class identityHash: identityHash [
	| object |
	object := class makeInstance: bytes size identityHash: identityHash.
	object slots last slots: bytes.
	^ object
]

{ #category : #'code generation' }
MbndSlovimObjectModel >> createObjectMethodDispatchTrampolineWithType: functionType [
	self assert: functionType isMbndType.
	^ moduleCodeGenerator getOrCreateObjectMethodDispatchTrampolineWithType: functionType
]

{ #category : #converting }
MbndSlovimObjectModel >> createSymbolObjectInstance: symbol [
	| data |
	^ convertedLiteralContent at: symbol ifAbsentPut: [
		data := symbol asUTF8Bytes.
		self createObjectBytes: data class: managedObjectModel symbolClass identityHash: (managedObjectModel computeBytesHash: data)
	]

]

{ #category : #converting }
MbndSlovimObjectModel >> createVariable: variable class: variableClass [
	| result variableName |
	result := variableClass makeInstance: 0 identityHash: self generateIdentityHash.
	self flag: 'Remove this ugly hack when Pharo 9 gets released.'.
	variableName := (variable respondsTo: #key)
		ifTrue: [ variable key ]
		ifFalse: [ variable name ].
	result
		setField: #name value: (self convertDynamicLiteralToConstant: variableName);
		setField: #value value: (self convertDynamicLiteralToConstant: variable value).
	^ result
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> dynamicObjectType [
	^ dynamicObjectType ifNil: [ dynamicObjectType := moduleCodeGenerator translateType: (moduleCodeGenerator compilationTarget dynamicObjectType) ]
]

{ #category : #'literal conversion' }
MbndSlovimObjectModel >> encodeInlineLiteral: literal [
	literal == true ifTrue: [ ^ self trueLiteralValue ].
	literal == false ifTrue: [ ^ self falseLiteralValue ].
	literal ifNil: [ ^ SLVMConstantValue type: target uintPointer value: 0 ].
	literal isInteger ifTrue: [ ^ SLVMConstantValue type: target uintPointer value: (self encodeSmallInteger: literal)].
	literal isCharacter ifTrue: [ ^ SLVMConstantValue type: target uintPointer value: (self encodeCharacter: literal)].
	literal isFloat ifTrue: [ ^ SLVMConstantValue type: target uintPointer value: (self encodeSmallFloat: literal)].
	self error: 'Should not reach here.'
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> falseLiteralValue [
	^ falseLiteralValue ifNil: [ falseLiteralValue := moduleCodeGenerator getOrCreateFalseLiteralValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> float64ToFloatFunction [
	<compileTime>
	^ float64ToFloatFunction ifNil: [float64ToFloatFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel float64ToFloatFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcBlockClosureAllocationFunction [
	<compileTime>
	^ gcBlockClosureAllocationFunction ifNil: [gcBlockClosureAllocationFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel gcBlockClosureAllocationFunction) ssaValue ]
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> gcBlockClosureHeaderConstant [
	| headerLiteralValue blockClosureLiteralValue |
	gcBlockClosureHeaderConstant ifNil:[
		headerLiteralValue := managedObjectModel blockClosureHeaderClass makeInstance: 0 identityHash: 0.
		
		"Transplant the vtable from the simple block closure into the header object."
		blockClosureLiteralValue := managedObjectModel simpleBlockClosureClass makeInstance: 0 identityHash: 0.
		headerLiteralValue slots at: 1 put: blockClosureLiteralValue slots first.
		
		gcBlockClosureHeaderConstant := moduleCodeGenerator translateDynamicObjectInstanceContent: headerLiteralValue.
		simpleGCBlockClosureDynamicCaptureCountSlotIndex := managedObjectModel simpleBlockClosureClass variableDataSizeField slotIndex
	]. 
	^ gcBlockClosureHeaderConstant
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> gcBlockClosureHeaderDynamicCallAdapterSlotIndex [
	^ gcBlockClosureHeaderDynamicCallAdapterSlotIndex ifNil: [gcBlockClosureHeaderDynamicCallAdapterSlotIndex := (managedObjectModel blockClosureHeaderClass findFirstFieldNamed: #startpc) slotIndex]
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> gcBlockClosureHeaderNumArgsSlotIndex [
	^ gcBlockClosureHeaderNumArgsSlotIndex ifNil: [gcBlockClosureHeaderNumArgsSlotIndex := (managedObjectModel blockClosureHeaderClass findFirstFieldNamed: #numArgs) slotIndex]
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> gcClosureHeaderType [
	^ gcClosureHeaderType ifNil: [ gcClosureHeaderType := (moduleCodeGenerator translateType: managedObjectModel blockClosureHeaderClass) baseType ]
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> gcModuleRootRegistrationPriority [
	^ managedObjectModel compilationTarget gcModuleRootRegistrationPriority
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcSafePointFunction [
	<compileTime>
	^ gcSafePointFunction ifNil: [gcSafePointFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel gcSafePointFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcShadowStackEnterFunction [
	<compileTime>
	^ gcShadowStackEnterFunction ifNil: [gcShadowStackEnterFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel gcShadowStackEnterFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcShadowStackLandingPadFunction [
	<compileTime>
	^ gcShadowStackLandingPadFunction ifNil: [gcShadowStackLandingPadFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel gcShadowStackLandingPadFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcShadowStackLeaveFunction [
	<compileTime>
	^ gcShadowStackLeaveFunction ifNil: [gcShadowStackLeaveFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel gcShadowStackLeaveFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcShadowStackRecordStructure [
	<compileTime>
	^ gcShadowStackRecordStructure ifNil: [gcShadowStackRecordStructure := moduleCodeGenerator translateType: managedObjectModel gcShadowStackRecordStructure ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcShadowStackRootCountField [
	<compileTime>
	^ gcShadowStackRootCountField ifNil: [gcShadowStackRootCountField := managedObjectModel gcShadowStackRecordStructure ifNotNil: [ :s | (s findFirstFieldNamed: #rootCount) slotIndex ] ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcShadowStackRootsField [
	<compileTime>
	^ gcShadowStackRootsField ifNil: [gcShadowStackRootsField := managedObjectModel gcShadowStackRecordStructure ifNotNil: [ :s | (s findFirstFieldNamed: #roots) slotIndex ] ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> gcrootIntrinsic [
	^ gcrootIntrinsic ifNil: [
		gcrootIntrinsic := SLVMConstantBuiltInFunction pointerSize: target pointerSize
			name: #'gc.root'
			functionType: (SLVMFunctionType callingConvention: #cdecl arguments: { target voidPointerPointerType . target voidPointerType } returnType: target void) ]
]

{ #category : #converting }
MbndSlovimObjectModel >> generateIdentityHash [
	^ moduleCodeGenerator generateIdentityHash
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> genericClosurePointerForKind: kind [
	kind = #gc ifTrue: [
		^ self dynamicObjectType
	].
	^ super genericClosurePointerForKind: kind
]

{ #category : #accessing }
MbndSlovimObjectModel >> globalVariableClass [
	^ managedObjectModel globalVariableClass
]

{ #category : #initialization }
MbndSlovimObjectModel >> initialize [
	super initialize.
	convertedLiteralContent := IdentityDictionary new.
	convertedLiteralGlobals := IdentityDictionary new.
	functionContextMetadata := IdentityDictionary new.
]

{ #category : #accessing }
MbndSlovimObjectModel >> inlineCacheStructure [
	<compileTime>
	^ inlineCacheStructure ifNil: [inlineCacheStructure := moduleCodeGenerator translateType: managedObjectModel inlineCacheStructure ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> int32ToIntegerFunction [
	<compileTime>
	^ int32ToIntegerFunction ifNil: [int32ToIntegerFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel int32ToIntegerFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> int64ToIntegerFunction [
	<compileTime>
	^ int64ToIntegerFunction ifNil: [int64ToIntegerFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel int64ToIntegerFunction) ssaValue ]
]

{ #category : #testing }
MbndSlovimObjectModel >> isClosureKindAllocatedInTheStack: kind [
	^ kind = #nativeStack
]

{ #category : #accessing }
MbndSlovimObjectModel >> managedObjectModel [
	^ managedObjectModel
]

{ #category : #accessing }
MbndSlovimObjectModel >> managedObjectModel: anObject [
	managedObjectModel := anObject
]

{ #category : #accessing }
MbndSlovimObjectModel >> messageLookupFunction [
	<compileTime>
	^ messageLookupFunction ifNil: [messageLookupFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel messageLookupFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> methodSuperClassGetter [
	<compileTime>
	^ methodSuperClassGetter ifNil: [methodSuperClassGetter := (moduleCodeGenerator translateProgramEntity: managedObjectModel methodSuperClassGetter) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> moduleCodeGenerator [
	^ moduleCodeGenerator
]

{ #category : #accessing }
MbndSlovimObjectModel >> moduleCodeGenerator: anObject [
	moduleCodeGenerator := anObject
]

{ #category : #accessing }
MbndSlovimObjectModel >> moduleRootRegistrationFunction [
	<compileTime>
	^ moduleRootRegistrationFunction ifNil: [moduleRootRegistrationFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel moduleRootRegistrationFunction) ssaValue ]
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> nativeClosureHeaderType [
	^ nativeClosureHeaderType ifNil: [ nativeClosureHeaderType := target voidPointerPointerType ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToBoolean8Function [
	<compileTime>
	^ objectToBoolean8Function ifNil: [objectToBoolean8Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToBoolean8Function) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToChar32Function [
	<compileTime>
	^ objectToChar32Function ifNil: [objectToChar32Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToChar32) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToFloat64Function [
	<compileTime>
	^ objectToFloat64Function ifNil: [objectToFloat64Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToFloat64Function) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToInt32Function [
	<compileTime>
	^ objectToInt32Function ifNil: [objectToInt32Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToInt32Function) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToInt64Function [
	<compileTime>
	^ objectToInt64Function ifNil: [objectToInt64Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToInt64Function) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToUInt32Function [
	<compileTime>
	^ objectToUInt32Function ifNil: [objectToUInt32Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToUInt32Function) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> objectToUInt64Function [
	<compileTime>
	^ objectToUInt64Function ifNil: [objectToUInt64Function := (moduleCodeGenerator translateProgramEntity: managedObjectModel objectToUInt64Function) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> receiverClassGetter [
	<compileTime>
	^ receiverClassGetter ifNil: [receiverClassGetter := (moduleCodeGenerator translateProgramEntity: managedObjectModel receiverClassGetter) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> stringClass [
	^ managedObjectModel stringClass
]

{ #category : #accessing }
MbndSlovimObjectModel >> superMessageLookupFunction [
	<compileTime>
	^ superMessageLookupFunction ifNil: [superMessageLookupFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel superMessageLookupFunction) ssaValue ]
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> trueLiteralValue [
	^ trueLiteralValue ifNil: [ trueLiteralValue := moduleCodeGenerator getOrCreateTrueLiteralValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> uint32ToCharacterFunction [
	<compileTime>
	^ uint32ToCharacterFunction ifNil: [uint32ToCharacterFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel uint32ToCharacterFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> uint32ToIntegerFunction [
	<compileTime>
	^ uint32ToIntegerFunction ifNil: [uint32ToIntegerFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel uint32ToIntegerFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> uint64ToIntegerFunction [
	<compileTime>
	^ uint64ToIntegerFunction ifNil: [uint64ToIntegerFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel uint64ToIntegerFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> workspaceVariableClass [
	^ managedObjectModel workspaceVariableClass
]
