Class {
	#name : #MbndAbstractSpecificMethod,
	#superclass : #MbndAbstractMethod,
	#instVars : [
		'receiverType',
		'type',
		'boundType',
		'lambdaCount',
		'nonLocalReturnTarget',
		'lambdaChildren',
		'nonLocalResultVariable',
		'typedSelector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #adding }
MbndAbstractSpecificMethod >> addLambdaChild: aLambda [
	aLambda lambdaIndex: lambdaCount.
	lambdaCount := lambdaCount + 1.
	lambdaChildren add: aLambda.
	^ super addLambdaChild: aLambda
]

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

	self hasAnonymousName ifFalse: [ 
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

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> analyzePragmaInDefinitionBodyWithSelector: selector arguments: arguments [
	super analyzePragmaInDefinitionBodyWithSelector: selector arguments: arguments.

	"Turn some pragmas into flags."
	(#(notInCompileTime compileTime gpu nogc staticBinding) includes: selector) ifTrue: [ 
		self addFlag: selector.
	].

]

{ #category : #'semantic analysis' }
MbndAbstractSpecificMethod >> applyInferredReturnType: aType at: aPosition [
	(self isForwardingValue or: self isAccessedByReference) ifTrue: [
		self returnType: aType
	] ifFalse: [
		self returnType: aType withoutReferences
	]
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> arguments [
	^ #()
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> boundType [
	boundType isClosure ifTrue: [ boundType := boundType value ].
	^ boundType
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> boundType: anObject [
	boundType := anObject
]

{ #category : #testing }
MbndAbstractSpecificMethod >> computeMatchingCostWithArguments: callArguments receiverType: callReceiverType analyzer: analyzer at: node [
	| coercionCost receiverConversionCost |
	receiverType isVoidType = callReceiverType isVoidType ifFalse: [ ^ nil ].
	self boundType isCVariadic ifTrue: [
		callArguments size >= self boundType argumentTypes size ifFalse: [ ^ nil ].
	] ifFalse: [
		callArguments size = self boundType argumentTypes size ifFalse: [ ^ nil ].
	].

	receiverConversionCost := 0.
	(receiverType isReferenceType and: [ callReceiverType isReferenceType or: [callReceiverType isTemporaryReferenceType ]]) ifTrue: [
		"Cannot cast const ref into non-const ref."
		callReceiverType baseType isConstantType ifTrue: [ 
			receiverType baseType isConstantType ifFalse: [ ^ nil ]
		].
	
		"Prefer the non-const version always."
		receiverType baseType isConstantType ~= callReceiverType baseType isConstantType ifTrue: [
			receiverConversionCost := 10.
		]
	].
	
	coercionCost := receiverConversionCost.
	callArguments doWithIndex: [ :argumentNode :index |
		| expectedType argumentCoercionCost |
		expectedType := self boundType argumentTypes at: index.
		argumentCoercionCost := analyzer computeImplicitCoercionCostFor: argumentNode to: expectedType at: node.
		argumentCoercionCost ifNil: [ ^ nil ].
		coercionCost := coercionCost + argumentCoercionCost
	].
	^ coercionCost
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> createDynamicMethodWrapper [
	^ nil
]

{ #category : #serialization }
MbndAbstractSpecificMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#flags . flags.
		#name . name .
		#receiverType . receiverType encodeGraphForMessagePackWith: graphEncoder.
		#type . self type encodeGraphForMessagePackWith: graphEncoder.
		#boundType . self boundType encodeGraphForMessagePackWith: graphEncoder.
	} , ((self needsDefinitionSerializedWith: graphEncoder) ifTrue: [ { 
		#nonLocalResultVariable . nonLocalResultVariable encodeGraphForMessagePackWith: graphEncoder.
		#typedSelector . typedSelector .
		#lambdaCount . lambdaCount.
		#lambdaChildren . lambdaChildren encodeGraphForMessagePackWith: graphEncoder.
	}] ifFalse: [ #() ])
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> ensureLookupSelectorIsRegisteredIn: programEntity [
	programEntity methodDict at: self typedSelector put: self.
	"programEntity methodDict at: name put: self."
	
	programEntity requiresDynamicMethodWrappers ifFalse: [ ^ self ].
	programEntity overloadedMethodDict at: name ifPresent: [ :existent |
		existent == self ifTrue: [
			self boundType needsSpecialTypedSelector ifTrue: [ 
				self createDynamicMethodWrapper ifNotNil: [ :wrapper |
					programEntity methodDict at: name put: wrapper
				].
			] ifFalse: [ 
				programEntity methodDict at: name put: self.
			]
		].
	].

]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> getNonLocalResultVariable [
	^ nonLocalResultVariable ifNil: [
		self returnType isVoidType ifTrue: [ ^ nil ].
		nonLocalResultVariable := MbndFunctionNonLocalReturnResultVariable new parent: self; valueType: self returnType asNonLocalReturnResultVariableType; yourself ]
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> getNonLocalReturnTarget [
	^ nonLocalReturnTarget ifNil: [ nonLocalReturnTarget := MbndFunctionReturnContextVariable new parent: self; valueType: self compilationTarget voidType pointer; yourself ]
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> getOrCreateCapturedVariableDefinition: capturedVariable [
	"At the end, just return the captured variable definition."
	self assert: capturedVariable parent == self.
	^ capturedVariable
]

{ #category : #testing }
MbndAbstractSpecificMethod >> hasAnonymousName [
	^ name isMbndAnonymousSymbol
]

{ #category : #testing }
MbndAbstractSpecificMethod >> hasVirtualTableEntry [
	^ self isNewVirtualTableEntry or: [ self isVirtualTableOverride ]
]

{ #category : #initialization }
MbndAbstractSpecificMethod >> initialize [
	super initialize.
	lambdaCount := 0.
	lambdaChildren := OrderedCollection new.
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isAbstractSpecificMethod [
	^ true
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isAbstractVirtualMethod [
	^ self hasFlag: #abstract
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isDefinition [
	^ false
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isNewVirtualTableEntry [
	^ (self hasFlag: #virtual) or: [ self isAbstractVirtualMethod ]
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isNoReturn [
	^ self hasFlag: #noReturn
]

{ #category : #testing }
MbndAbstractSpecificMethod >> isVirtualTableOverride [
	^ self hasFlag: #override
]

{ #category : #testing }
MbndAbstractSpecificMethod >> matchesPrototypeNode: prototypeNode withReceiverType: prototypeReceiverType [
	receiverType == prototypeReceiverType ifFalse: [ ^ false ].
	self boundType returnType == prototypeNode returnType ifFalse: [ ^ false ].
	prototypeNode arguments size = self boundType argumentTypes size ifFalse: [ ^ false ].
	prototypeNode isCVariadic = self boundType isCVariadic ifFalse: [ ^ false ].
	
	(1 to: prototypeNode arguments size) do: [ :i |
		(self boundType argumentTypes at: i) = (prototypeNode arguments at: i) ifFalse: [ ^ false ].
	].
	
	^ true
]

{ #category : #serialization }
MbndAbstractSpecificMethod >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	flags := encodedFields at: #flags.
	name := encodedFields at: #name.
	receiverType := encodedFields at: #receiverType.
	type := encodedFields at: #type.
	boundType := encodedFields at: #boundType.

	nonLocalResultVariable := encodedFields at: #nonLocalResultVariable ifAbsent: [nil].
	typedSelector := encodedFields at: #typedSelector ifAbsent: [nil].
	lambdaCount := encodedFields at: #lambdaCount ifAbsent: [0].
	lambdaChildren := encodedFields at: #lambdaChildren ifAbsent: [OrderedCollection new].
]

{ #category : #composition }
MbndAbstractSpecificMethod >> mbndLiteralTypeWithTarget: compilationTarget [
	^ self type ref
]

{ #category : #testing }
MbndAbstractSpecificMethod >> mustBeAvailableInTheGPU [
	^ (self hasFlag: #gpu) or: [parent mustBeAvailableInTheGPU]
]

{ #category : #testing }
MbndAbstractSpecificMethod >> needsDefinitionSerializedWith: graphEncoder [
	self canBeEvaluatedInCompileTime ifFalse: [ ^ false ].
	^ self isConcreteMacroMessage
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> parent: aParent [
	super parent: aParent.
	
	(self hasAnonymousName and: [self isFunclet not and: [self isModuleSpecializedProgramEntity not]]) ifTrue: [
		name := self module generateAnonymousSymbolName
	].
]

{ #category : #printing }
MbndAbstractSpecificMethod >> printOn: aStream [
	aStream nextPutAll: 'function '.
	^ aStream nextPutAll: self qualifiedName.
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> receiverType [
	^ receiverType
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> receiverType: anObject [
	receiverType := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> recordAsExtensionFor: ownerProgramEntity withSelector: registeredSelector [
	self assert: registeredSelector = name.
	self module
		recordExtensionFor: ownerProgramEntity overloadedMethod: self withSelector: registeredSelector;
		recordExtensionFor: ownerProgramEntity method: self withSelector: self typedSelector.
	
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> returnType: newReturnType [
	self assert: self returnType isNil.
	boundType := self boundType withReturnType: newReturnType.
	type := self type withReturnType: newReturnType.
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> sendTypedSelector [
	^ self typedSelector
]

{ #category : #asserting }
MbndAbstractSpecificMethod >> shouldMangleReturnType [
	^ parent isMbndType and: [ parent isGarbageCollectedType ]
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> specialSemantics [
	^ nil
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> type [
	type isClosure ifTrue: [ type := type value ].
	^ type
]

{ #category : #accessing }
MbndAbstractSpecificMethod >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> typedSelector [
	name ifNil: [ ^ nil ].
	typedSelector ifNil: [
		typedSelector := super typedSelector.
		self boundType needsSpecialTypedSelector ifTrue: [
			typedSelector := (typedSelector , '|' , self boundType typedSelectorSpec) asSymbol.
		].
	].
	^ typedSelector
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> virtualTableSelector [
	^ {name . self vtableEntryKind . self boundType }
]

{ #category : #'as yet unclassified' }
MbndAbstractSpecificMethod >> vtableEntryKind [
	^ #message
]
