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

	node type: returnType.
	^ node
]

{ #category : #accessing }
MbndFunctionType >> argumentTypes [
	^ argumentTypes
]

{ #category : #accessing }
MbndFunctionType >> argumentTypes: anObject [
	argumentTypes := anObject
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> asBlockClosureType [
	^ self compilationTarget blockClosureTypeWithSignature: self
]

{ #category : #accessing }
MbndFunctionType >> callingConvention [
	^ callingConvention
]

{ #category : #accessing }
MbndFunctionType >> callingConvention: anObject [
	callingConvention := anObject
]

{ #category : #accessing }
MbndFunctionType >> cvariadic [
	^ cvariadic
]

{ #category : #accessing }
MbndFunctionType >> cvariadic: anObject [
	cvariadic := anObject
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
	^ true
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> prependArguments: newArguments [
	^ self compilationTarget functionTypeWithArguments: newArguments , argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic
]

{ #category : #printing }
MbndFunctionType >> printOn: aStream [
	aStream nextPut: $(.
	argumentTypes doWithIndex: [ :arg :index |
		index > 1 ifTrue: [ aStream nextPutAll: ', ' ].
		arg printOn: aStream
	].
	aStream nextPutAll: ') => '.
	returnType printOn: aStream.
]

{ #category : #accessing }
MbndFunctionType >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndFunctionType >> returnType: anObject [
	returnType := anObject
]

{ #category : #'as yet unclassified' }
MbndFunctionType >> withExplicitReceiverType: receiverType [
	^ self compilationTarget functionTypeWithArguments: {receiverType} , argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic

]
