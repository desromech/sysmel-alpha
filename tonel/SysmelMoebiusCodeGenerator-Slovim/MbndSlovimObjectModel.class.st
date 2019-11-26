Class {
	#name : #MbndSlovimObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'managedObjectModel',
		'moduleCodeGenerator',
		'convertedSymbolDictionary',
		'gcrootIntrinsic',
		'messageLookupFunction'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #converting }
MbndSlovimObjectModel >> computeBytesHash: data [
	^ self computeBytesHash: data initialHash: 5381
]

{ #category : #converting }
MbndSlovimObjectModel >> computeBytesHash: data initialHash: initialHash [
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

{ #category : #converting }
MbndSlovimObjectModel >> convertInlineLiteral: literalValue withType: targetType [
	^ SLVMConstantValue type: targetType value: literalValue
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

{ #category : #converting }
MbndSlovimObjectModel >> createNonInlineLiteralConstant: aLiteral withCodeGenerator: aCodeGenerator [
	^ moduleCodeGenerator translateDynamicObjectInstanceContent:( aLiteral createNonInlineLiteralObjectForMbndObjectModel: self)
]

{ #category : #converting }
MbndSlovimObjectModel >> createNonInlineLiteralUniqueGlobal: aLiteral withCodeGenerator: codeGenerator [
	aLiteral isMbndProgramEntity ifTrue: [
		^ (moduleCodeGenerator translateProgramEntity: aLiteral) ssaValue
	].
	^ nil
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
	^ convertedSymbolDictionary at: symbol ifAbsentPut: [
		data := symbol asUTF8Bytes.
		self createObjectBytes: data class: managedObjectModel symbolClass identityHash: (self computeBytesHash: data)
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
	convertedSymbolDictionary := IdentityDictionary new.
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
