Class {
	#name : #SYMLSLVMObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'arrayClass',
		'byteArrayClass',
		'compiledMethodClass',
		'dictionaryClass',
		'methodDictionaryClass',
		'stringClass',
		'symbolClass',
		'sysmelSuperMessageLookupFunction',
		'sysmelMessageLookupFunction',
		'convertedLiteralDictionary',
		'compiledMethodEntryPointSlotIndex',
		'identityHashRandomGenerator',
		'gcrootIntrinsic'
	],
	#category : #'Sysmel-Metamodel-CompilationTarget'
}

{ #category : #accessing }
SYMLSLVMObjectModel >> arrayClass [
	<compileTime>
	^ arrayClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> arrayClass: anObject [
	<compileTime>
	arrayClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> byteArrayClass [
	<compileTime>
	^ byteArrayClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> byteArrayClass: anObject [
	<compileTime>
	byteArrayClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> compiledMethodClass [
	<compileTime>
	^ compiledMethodClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> compiledMethodClass: anObject [
	<compileTime>
	compiledMethodClass := anObject
]

{ #category : #visiting }
SYMLSLVMObjectModel >> compiledMethodEntryPointSlotIndex [
	^ compiledMethodEntryPointSlotIndex ifNil: [ compiledMethodEntryPointSlotIndex := compiledMethodClass getFieldSlotIndex: #entryPoint ]
]

{ #category : #'as yet unclassified' }
SYMLSLVMObjectModel >> computeBytesHash: data [
	^ self computeBytesHash: data initialHash: 5381
]

{ #category : #'as yet unclassified' }
SYMLSLVMObjectModel >> computeBytesHash: data initialHash: initialHash [
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

{ #category : #'code generation' }
SYMLSLVMObjectModel >> createDoesNotUnderstandTrampolineWithType: functionType [
	| function builder entryBlock boxedMessage result convertedResult |
	function := SLVMFunction pointerSize: target pointerSize functionType: functionType.
	function
		compilationTarget: target;
		propertyAt: #omitDebugInformation put: true;
		propertyAt: #dnuTrampoline put: true;
		gcStrategy: #sysmel.
	
	
	builder := SLVMBuilder on: function.
	
	entryBlock := builder newBasicBlockHere: #entry.
	
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
		function returnType isVoidType ifTrue: [
			builder returnVoid
		] ifFalse: [ 
			self flag: 'TODO: Unbox the result.'.
			builder return: function returnType defaultValue
		].
	].

	^ function
]

{ #category : #visiting }
SYMLSLVMObjectModel >> createFunctionContextMetaData: aFunction [
	| literals compiledMethod |
	literals := aFunction dynamicLiterals.
	compiledMethod := compiledMethodClass makeInstance: literals size.

	compiledMethod slots
		at: self compiledMethodEntryPointSlotIndex + 1 put: aFunction;
		at: compiledMethod slots size put: (literals collect: [:lit | lit value createNonInlineLiteralObjectForSysmelObjectModel: self ] as: Array).
	^ compiledMethod
]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createNonInlineLiteralConstant: aLiteral withCodeGenerator: aCodeGenerator [
	^ self ssaInitialValueConstantForObjectInstance: (aLiteral createNonInlineLiteralObjectForSysmelObjectModel: self)

]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createNonInlineLiteralUniqueGlobal: aLiteral withCodeGenerator: codeGenerator [
	^ convertedLiteralDictionary at: aLiteral ifPresent: [ :convertedLiteral |
		^ convertedLiteral ssaGlobalVariable
	] ifAbsent: [ nil ]

]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createObjectBytes: bytes class: class [
	^ self createObjectBytes: bytes class: class identityHash: self generateIdentityHash
]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createObjectBytes: bytes class: class identityHash: identityHash [
	| object |
	object := class makeInstance: bytes size identityHash: identityHash.
	object slots at: object slots size put: bytes.
	^ object
]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createSymbolObjectInstance: symbol [
	| data |
	^ convertedLiteralDictionary at: symbol ifAbsentPut: [
		data := symbol asUTF8Bytes.
		self createObjectBytes: data class: symbolClass identityHash: (self computeBytesHash: data)
	]

]

{ #category : #accessing }
SYMLSLVMObjectModel >> dictionaryClass [
	<compileTime>
	^ dictionaryClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> dictionaryClass: anObject [
	<compileTime>
	dictionaryClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> gcrootIntrinsic [
	^ gcrootIntrinsic ifNil: [
		gcrootIntrinsic := SLVMConstantBuiltInFunction pointerSize: target pointerSize
			name: #'gc.root'
			functionType: (SLVMFunctionType callingConvention: #cdecl arguments: { target voidPointerPointerType . target voidPointerType } returnType: target void) ]
]

{ #category : #initialization }
SYMLSLVMObjectModel >> generateIdentityHash [
	^ (identityHashRandomGenerator nextInt: (1<<32) + 1) - 1 
]

{ #category : #initialization }
SYMLSLVMObjectModel >> initialize [
	super initialize.
	convertedLiteralDictionary := IdentityDictionary new.
	identityHashRandomGenerator := Random seed: 0.
]

{ #category : #accessing }
SYMLSLVMObjectModel >> messageLookupFunction [
	<compileTime>
	^ sysmelMessageLookupFunction ssaValue
]

{ #category : #accessing }
SYMLSLVMObjectModel >> methodDictionaryClass [
	<compileTime>
	^ methodDictionaryClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> methodDictionaryClass: anObject [
	<compileTime>
	methodDictionaryClass := anObject
]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> ssaInitialValueConstantForObjectInstance: objectInstance [
	^ objectInstance createSSAInitialValueConstant
]

{ #category : #accessing }
SYMLSLVMObjectModel >> stringClass [
	<compileTime>
	^ stringClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> stringClass: anObject [
	<compileTime>
	stringClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> superMessageLookupFunction [
	<compileTime>
	^ sysmelSuperMessageLookupFunction ssaValue
]

{ #category : #accessing }
SYMLSLVMObjectModel >> symbolClass [
	<compileTime>
	^ symbolClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> symbolClass: anObject [
	<compileTime>
	symbolClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelMessageLookupFunction [
	<compileTime>
	^ sysmelMessageLookupFunction 
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelMessageLookupFunction: anObject [
	<compileTime>
	sysmelMessageLookupFunction := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelSuperMessageLookupFunction [
	<compileTime>
	^ sysmelSuperMessageLookupFunction
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelSuperMessageLookupFunction: anObject [
	<compileTime>
	sysmelSuperMessageLookupFunction := anObject
]
