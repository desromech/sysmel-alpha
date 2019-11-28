Class {
	#name : #MbndSlovimObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'managedObjectModel',
		'moduleCodeGenerator',
		'gcrootIntrinsic',
		'messageLookupFunction',
		'convertedLiteralContent',
		'convertedLiteralGlobals'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #accessing }
MbndSlovimObjectModel >> arrayClass [
	^ managedObjectModel arrayClass
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> convertDynamicLiteralToConstant: dynamicLiteralValue [
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

	literalGlobal := SLVMGlobalVariable module: moduleCodeGenerator ssaModule name: nil valueType: initialValue type storage: SLVMType genericStorage.
	literalGlobal makePrivate; initialValue: initialValue.
	
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

{ #category : #'code generation' }
MbndSlovimObjectModel >> createDoesNotUnderstandTrampolineWithType: functionType [
	| function builder boxedMessage result convertedResult |
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
	| literals compiledMethod |
	literals := aFunction dynamicLiterals.
	compiledMethod := managedObjectModel compiledMethodClass makeInstance: literals size identityHash: 0.

	compiledMethod setField: #entryPoint value: aFunction.
	compiledMethod slots last slots: (literals collect: #value as: Array).
	^ compiledMethod
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

{ #category : #converting }
MbndSlovimObjectModel >> createSymbolObjectInstance: symbol [
	| data |
	^ convertedLiteralContent at: symbol ifAbsentPut: [
		data := symbol asUTF8Bytes.
		self createObjectBytes: data class: managedObjectModel symbolClass identityHash: (managedObjectModel computeBytesHash: data)
	]

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

{ #category : #initialization }
MbndSlovimObjectModel >> initialize [
	super initialize.
	convertedLiteralContent := IdentityDictionary new.
	convertedLiteralGlobals := IdentityDictionary new.
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
MbndSlovimObjectModel >> moduleCodeGenerator [
	^ moduleCodeGenerator
]

{ #category : #accessing }
MbndSlovimObjectModel >> moduleCodeGenerator: anObject [
	moduleCodeGenerator := anObject
]
