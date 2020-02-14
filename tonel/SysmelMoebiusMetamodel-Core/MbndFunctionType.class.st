Class {
	#name : #MbndFunctionType,
	#superclass : #MbndFunctionalType,
	#instVars : [
		'argumentTypes',
		'returnType',
		'callingConvention',
		'cvariadic'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionType class >> typeName [
	^ #_FunctionType
]

{ #category : #visiting }
MbndFunctionType >> accept: aVisitor [
	^ aVisitor visitFunctionType: self
]

{ #category : #initialization }
MbndFunctionType >> addInstanceMacros [
	self class == MbndFunctionType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self onMacroSelector: #shaderEntryPointInfo do: [ :node :builder |
		node receiver isMethodReferenceNode ifFalse: [ 
			self error: 'A direct method reference is required for the shaderEntryPointInfo macro.' at: node
		].
		node receiver binding shaderEntryPointInfoReferenceNodeAt: node
	].
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> analyzeFunctionCallNode: node with: analyzer [
	node arguments size < argumentTypes size ifTrue: [
		self error: 'Fewer arguments than required are passed in function call. Expected {1} arguments.'
			format: { argumentTypes size asString } at: node
	] ifFalse: [
		(node arguments size > argumentTypes size and: [ cvariadic not ]) ifTrue: [ 
			self error: 'More arguments than required are passed in function call. Expected {1} arguments.'
			format: { argumentTypes size asString } at: node
		].
	].

	node arguments: (node arguments collectWithIndex: [:arg :index |
		index <= argumentTypes size ifTrue: [ 
			analyzer addImplicitCastFor: arg to: (argumentTypes at: index)
		] ifFalse: [ 
			analyzer addImplicitCVariadicCastFor: arg
		]
	]).

	node function calledFunctionBinding ifNotNil: [ :function |
		function canBeEvaluatedInCompileTime ifFalse: [
			analyzer markCompileTimeEvaluationImpossibility. 
		]
	].

	node
		functionReturnType: returnType;
		type: returnType.
	
	returnType hasTrivialFinalization ifFalse: [
		analyzer addNodeWithImplicitFinalization: node
	].
	returnType isMemoryReturnedType ifTrue: [ 
		node type: returnType tempRef
	].

	^ node
]

{ #category : #accessing }
MbndFunctionType >> argumentTypes [
	<compileTime>
	^ argumentTypes
]

{ #category : #accessing }
MbndFunctionType >> argumentTypes: anObject [
	argumentTypes := anObject
]

{ #category : #converting }
MbndFunctionType >> asDynamicMethodWrapperType [
	^ self compilationTarget
		functionTypeWithArguments: (argumentTypes collect: [:each | each asDynamicMethodWrapperType])
		returnType: returnType
		asDynamicMethodWrapperType callingConvention: callingConvention cvariadic: false
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> asGCBlockClosureType [
	^ self compilationTarget blockClosureTypeWithSignature: self
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> asNativeBlockClosureType [
	^ self compilationTarget nativeBlockClosureTypeWithSignature: self
]

{ #category : #accessing }
MbndFunctionType >> callingConvention [
	<compileTime>
	^ callingConvention
]

{ #category : #accessing }
MbndFunctionType >> callingConvention: anObject [
	callingConvention := anObject
]

{ #category : #accessing }
MbndFunctionType >> cvariadic [
	<compileTime>
	^ cvariadic
]

{ #category : #accessing }
MbndFunctionType >> cvariadic: anObject [
	cvariadic := anObject
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> gcBlockClosure [
	<compileTime>
	^ self asGCBlockClosureType 
]

{ #category : #initialization }
MbndFunctionType >> initialize [
	super initialize.
	callingConvention ifNil: [callingConvention := #cdecl].
	cvariadic ifNil: [cvariadic := false].
]

{ #category : #testing }
MbndFunctionType >> isCVariadic [
	^ cvariadic
]

{ #category : #testing }
MbndFunctionType >> isFunctionType [
	<compileTime>
	^ true
]

{ #category : #'testing methods' }
MbndFunctionType >> isPossibleToLoadReferences [
	^ false
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> nativeBlockClosure [
	<compileTime>
	^ self asNativeBlockClosureType 
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> nativeStackBlockClosure [
	<compileTime>
	^ self asNativeBlockClosureType 
]

{ #category : #testing }
MbndFunctionType >> needsSpecialTypedSelector [
	| dynobjectType |
	dynobjectType := self compilationTarget dynamicObjectType.
	dynobjectType ifNil: [ ^ true ].
	cvariadic ifTrue: [ ^ true ].
	
	argumentTypes do: [ :arg |
		arg ~~ dynobjectType ifTrue: [ ^ true ].
	].

	^ returnType isGarbageCollectedType not
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> prependArguments: newArguments [
	^ self compilationTarget functionTypeWithArguments: newArguments , argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic
]

{ #category : #printing }
MbndFunctionType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].

	aStream nextPut: $(.
	argumentTypes ifNotNil: [ 
		argumentTypes doWithIndex: [ :arg :index |
			index > 1 ifTrue: [ aStream nextPutAll: ', ' ].
			arg printOn: aStream
		].
	].
	aStream nextPutAll: ') => '.
	returnType printOn: aStream.
]

{ #category : #accessing }
MbndFunctionType >> returnType [
	<compileTime>
	^ returnType
]

{ #category : #accessing }
MbndFunctionType >> returnType: anObject [
	returnType := anObject
]

{ #category : #testing }
MbndFunctionType >> typedSelectorSpec [
	^ ByteString streamContents: [ :out |
		argumentTypes doWithIndex: [ :arg :index|
			index > 1 ifTrue: [ 
				out nextPut: $,.
			].
			out nextPutAll: arg asString.
		].

		out nextPutAll: '::';
			nextPutAll: 	returnType asString
	].

]

{ #category : #'as yet unclassified' }
MbndFunctionType >> withExplicitReceiverType: receiverType [
	^ self compilationTarget functionTypeWithArguments: {receiverType} , argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic

]

{ #category : #'as yet unclassified' }
MbndFunctionType >> withReturnType: newReturnType [
	^ self compilationTarget functionTypeWithArguments: argumentTypes returnType: newReturnType callingConvention: callingConvention cvariadic: cvariadic
]
