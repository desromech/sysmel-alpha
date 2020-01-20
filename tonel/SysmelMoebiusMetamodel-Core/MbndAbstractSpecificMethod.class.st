Class {
	#name : #MbndAbstractSpecificMethod,
	#superclass : #MbndAbstractMethod,
	#instVars : [
		'receiverType',
		'type',
		'boundType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #'semantic analysis' }
MbndAbstractSpecificMethod >> analyzeExpandedMessageSendNode: node with: analyzer [
	| newReceiverNode argumentTypes newArgumentNodes result |
	node receiver ifNotNil: [ :receiverNode |
		receiverNode type isNamespaceType ifTrue: [
			^ self analyzeExpandedMessageSendNode: (node copy receiver: nil) with: analyzer
		].
	].

	self receiverType isVoidType ~= node receiver isNil ifTrue: [
		self error: 'analyzing message send {1} with mismatching presence or lack of receiver types.'
			format: {self name asPrettySymbolName} at: node
	].

	self boundType argumentTypes size ~= node arguments size ifTrue: [ 
		self error: 'message send {1} with mismatching number of arguments. Expected {2} arguments.'
			format: {self name asPrettySymbolName . self boundType argumentTypes size asString} at: node
	].

	newReceiverNode := node receiver ifNotNil: [ :receiver |
		analyzer addReceiverImplicitCastFor: (analyzer analyzeNodeIfNeeded: receiver) to: self receiverType 
	].

	argumentTypes := self boundType argumentTypes.
	newArgumentNodes := node arguments collectWithIndex: [ :argumentNode :index |
		analyzer addImplicitCastFor: argumentNode to: (argumentTypes at: index)
	].

	self canBeEvaluatedInCompileTime ifFalse: [ 
		analyzer markCompileTimeEvaluationImpossibility
	].

	name isMbndAnonymousSymbol ifFalse: [ 
		newReceiverNode ifNotNil: [ 
			newReceiverNode isSuperReference ifTrue: [
				analyzer scope lookupFunctionProgramEntity ifNotNil: [ :callingFunction |
					callingFunction name = name ifTrue: [ 
						callingFunction markExplicitSuperSend
					]
				].
			].
		].
	].

	result := node copy
		method: self;
		receiver: newReceiverNode;
		arguments: newArgumentNodes;
		methodReturnType: (self returnType asResultTypeWithReceiver: node receiver withArguments: newArgumentNodes );
		yourself.
	result methodReturnType hasTrivialFinalization ifFalse: [
		analyzer addNodeWithImplicitFinalization: result
	].

	"The return type of the node may be different to the actual return type of the method."
	result type: result methodReturnType.
	result methodReturnType isMemoryReturnedType ifTrue: [
		result type: result methodReturnType tempRef
	].
	^ result
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> arguments [
	^ #()
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> boundType [
	^ boundType
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> boundType: anObject [
	boundType := anObject
]

{ #category : #testing }
MbndAbstractSpecificMethod >> computeMatchingCostWithArguments: callArguments receiverType: callReceiverType analyzer: analyzer at: node [
	| coercionCost |
	receiverType isVoidType = callReceiverType isVoidType ifFalse: [ ^ nil ].
	boundType isCVariadic ifTrue: [
		callArguments size >= boundType argumentTypes size ifFalse: [ ^ nil ].
	] ifFalse: [
		callArguments size = boundType argumentTypes size ifFalse: [ ^ nil ].
	].

	coercionCost := 0.
	callArguments doWithIndex: [ :argumentNode :index |
		| expectedType argumentCoercionCost |
		expectedType := boundType argumentTypes at: index.
		argumentCoercionCost := analyzer computeImplicitCoercionCostFor: argumentNode to: expectedType at: node.
		argumentCoercionCost ifNil: [ ^ nil ].
		coercionCost := coercionCost + argumentCoercionCost
	].
	^ coercionCost
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> getOrCreateCapturedVariableDefinition: capturedVariable [
	"At the end, just return the captured variable definition."
	self assert: capturedVariable parent == self.
	^ capturedVariable
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isAbstractSpecificMethod [
	^ true
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isDefinition [
	^ false
]

{ #category : #testing }
MbndAbstractSpecificMethod >> matchesPrototypeNode: prototypeNode withReceiverType: prototypeReceiverType [
	receiverType == prototypeReceiverType ifFalse: [ ^ false ].
	boundType returnType == prototypeNode returnType ifFalse: [ ^ false ].
	prototypeNode arguments size = boundType argumentTypes size ifFalse: [ ^ false ].
	prototypeNode isCVariadic = boundType isCVariadic ifFalse: [ ^ false ].
	
	(1 to: prototypeNode arguments size) do: [ :i |
		(boundType argumentTypes at: i) = (prototypeNode arguments at: i) ifFalse: [ ^ false ].
	].
	
	^ true
]

{ #category : #composition }
MbndAbstractSpecificMethod >> mbndLiteralTypeWithTarget: compilationTarget [
	^ type ref
]

{ #category : #printing }
MbndAbstractSpecificMethod >> printOn: aStream [
	name ifNotNil: [ ^ aStream nextPutAll: name ].
	aStream nextPutAll: '__anon'
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> receiverType [
	^ receiverType
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> receiverType: anObject [
	receiverType := anObject
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> specialSemantics [
	^ nil
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> type [
	^ type
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> type: anObject [
	type := anObject
]
