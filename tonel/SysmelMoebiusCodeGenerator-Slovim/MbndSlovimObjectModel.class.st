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
		'falseLiteralValue'
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
MbndSlovimObjectModel >> classVariableClass [
	^ managedObjectModel classVariableClass
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

	literalGlobal := SLVMGlobalVariable module: moduleCodeGenerator ssaModule name: dynamicLiteralName valueType: initialValue type storage: SLVMType genericStorage.
	literalGlobal makePrivate; initialValue: initialValue.
	
	convertedValue value: literalGlobal targetType: targetType.
	^ convertedValue
]

{ #category : #'literal conversion' }
MbndSlovimObjectModel >> convertInlineLiteral: literal [
	literal == true ifTrue: [ ^ self trueLiteralValue ].
	literal == false ifTrue: [ ^ self falseLiteralValue ].
	literal ifNil: [ ^ SLVMConstantValue type: target dynamicObjectType value: nil ].
	literal isInteger ifTrue: [ ^ SLVMConstantValue type: target dynamicObjectType value: (self encodeSmallInteger: literal)].
	literal isCharacter ifTrue: [ ^ SLVMConstantValue type: target dynamicObjectType value: (self encodeSmallInteger: literal)].
	literal isFloat ifTrue: [ ^ SLVMConstantValue type: target dynamicObjectType value: (self encodeSmallFloat: literal)].
	self error: 'Should not reach here.'
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
MbndSlovimObjectModel >> falseClass [
	^ managedObjectModel falseClass
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> falseLiteralValue [
	| literalValue |
	^ falseLiteralValue ifNil: [ 
		literalValue := self falseClass makeInstance: 0 identityHash: self generateIdentityHash.
		falseLiteralValue := self convertDynamicLiteralToConstant: literalValue withName: '_S9Smalltalk_false'.
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

{ #category : #accessing }
MbndSlovimObjectModel >> globalVariableClass [
	^ managedObjectModel globalVariableClass
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

{ #category : #accessing }
MbndSlovimObjectModel >> superMessageLookupFunction [
	<compileTime>
	^ superMessageLookupFunction ifNil: [superMessageLookupFunction := (moduleCodeGenerator translateProgramEntity: managedObjectModel superMessageLookupFunction) ssaValue ]
]

{ #category : #accessing }
MbndSlovimObjectModel >> trueClass [
	^ managedObjectModel trueClass
]

{ #category : #'as yet unclassified' }
MbndSlovimObjectModel >> trueLiteralValue [
	| literalValue |
	^ trueLiteralValue ifNil: [ 
		literalValue := self trueClass makeInstance: 0 identityHash: self generateIdentityHash.
		trueLiteralValue := self convertDynamicLiteralToConstant: literalValue withName: '_S9Smalltalk_true'.
	]
]

{ #category : #accessing }
MbndSlovimObjectModel >> workspaceVariableClass [
	^ managedObjectModel workspaceVariableClass
]
