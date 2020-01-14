Class {
	#name : #MbndSlovimFunctionCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'ssaFunction',
		'concreteMethod',
		'slvmBuilder',
		'functionVariables',
		'currentBreakBlock',
		'currentContinueBlock',
		'currentCleanUpScope',
		'ssaFunctionEntryBlock',
		'ssaFunctionBodyBlock',
		'activeLexicalScope',
		'implicitCleanUpActionStates',
		'storageCreationNodeVariableMapForCopyEllision'
	],
	#classVars : [
		'AdditionalIntrinsicsDictionary',
		'EvaluationOnlyIntrinsics',
		'IntrinsicTargetMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimFunctionCodeGenerator class >> initialize [
	AdditionalIntrinsicsDictionary := Dictionary newFromPairs: #(
		#'vector.length2' generateVectorLength2Intrinsic:
		#'vector.cross.2d' generateVectorCross2DIntrinsic:
		#'dynobject.identityEquals' generateIdentityEquals:
		#'dynobject.identityNotEquals' generateIdentityNotEquals:
	).
	
	EvaluationOnlyIntrinsics := Set newFrom: #(
		#'dynobject.class'
		#'dynobject.identityHash'
		#'gc.object.basicNew' #'gc.object.basicNew.variable'
	).
	
	IntrinsicTargetMap := Dictionary newFromPairs: #(
	).
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> addLocalVariable: localVariable withValueType: valueType cleanUpActionForNode: node [
	self generateCleanUpActionActivatedHereForNode: node token: localVariable asCanonicalLocalReference with: [
		self generateVariable: localVariable finalizationForValueType: valueType
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> aggregate: aggregateNode value: aggregateValue getFieldOverrideFor: field [
	| valueType referenceType |
	self slvmCompilationTarget isGPU ifFalse: [ ^ nil ].
	
	valueType := field valueType.
	referenceType := field type.
	(valueType isPointerLikeValueType and: [ valueType addressSpace = #bindingSet ]) ifTrue: [
		self assert: aggregateValue isFunctionArgument.
		^ MbndSlovimDescriptorSetReference new
			setIndex: field asDescriptorSetIndex;
			valueType: field valueType;
			yourself
	].

	(valueType isPointerLikeValueType and: [ valueType addressSpace = #pushConstant ]) ifTrue: [
		self assert: aggregateValue isFunctionArgument.
		^ MbndSlovimLoadedReferenceValue new
			value: (codeModuleGenerator getFieldAsPushConstantReference: field)
	].

	(referenceType isReferenceType and: [ #(#workgroup crossWorkgroup) includes: referenceType addressSpace ]) ifTrue: [ 
		self assert: aggregateValue isFunctionArgument.
		^ codeModuleGenerator getField: field asSharedStorageWithType: referenceType addressSpace
	].

	(aggregateValue isFakeValue and: [ aggregateValue isMbndDescriptorSetReference ]) ifTrue: [ 
		valueType isPointerLikeValueType ifTrue: [ 
			self assert: (#(uniformBuffer storageBuffer) includes: valueType addressSpace).
			^ MbndSlovimLoadedReferenceValue new value: 
				(codeModuleGenerator getField: field fromDescriptorSet: aggregateValue)
		].
		^ codeModuleGenerator getField: field fromDescriptorSet: aggregateValue
	].

	^ nil
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> allocateTemporaryStorageFor: valueType withStorageCreationNode: storageCreationNode [
	| actualValueType |
	actualValueType := self sanitizeValueTypeForMemory: valueType.
	storageCreationNode ifNotNil: [
		storageCreationNodeVariableMapForCopyEllision at: storageCreationNode ifPresent: [ :ellisionStorage |
			self assert: ellisionStorage type isPointerType.
			ellisionStorage type baseType = actualValueType ifTrue: [ 
				^ ellisionStorage
			].
		]
	].
	^ slvmBuilder allocaBuilder alloca: actualValueType
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> buildSSAFunction: aSSAFunction at: sourcePosition withCodeGenerationBlock: codeGenerationBlock [
	ssaFunction := aSSAFunction.
	functionVariables := Dictionary new.
	
	self setupBuilders.

	"Generate the body code."
	self withDebugPosition: (codeModuleGenerator convertDebugPosition: sourcePosition asActualSourcePosition) do: [ 
		codeGenerationBlock value: ssaFunction value: slvmBuilder value: self.
	].

	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> buildSSAFunction: aSSAFunction definitionWithConcreteMethod: aConcreteMethod [
	(self setupSSAFunction: aSSAFunction definitionWithMethod: aConcreteMethod) ifTrue: [ ^ self ].

	self generateAutomaticPrologueCode.
	
	"Generate the body code."
	self visitNode: concreteMethod analyzedBody.

	"Semantic analysis introduces an implicit return, so this should be always a terminator."
	self assert: slvmBuilder currentBlock isLastTerminator.
	self assert: concreteMethod analyzedBody type isReturnType.

	"Initialize the required clean up action states in the alloca block."
	self initializeCleanUpActionStates.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	concreteMethod requiresCompiledMethodMetadata ifTrue: [
		ssaFunction
			addRequiredDynamicLiteral: concreteMethod selectorRequiredLiteral;
			addRequiredDynamicLiteral: concreteMethod classBindingLiteral;
			hasSelectorAndClassBinding: true
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> buildSSAFunction: aSSAFunction definitionWithMethod: aConcreteMethod withCodeGenerationBlock: codeGenerationBlock [
	| funcletValue |
	(self setupSSAFunction: aSSAFunction definitionWithMethod: aConcreteMethod) ifTrue: [ ^ self ].
	
	"Generate the body code."
	concreteMethod isFunclet ifTrue: [ 
		funcletValue := self visitNode: concreteMethod analyzedBody.
		self withDebugPosition: (codeModuleGenerator convertDebugPosition: aConcreteMethod definitionPosition asActualSourcePosition) do: [ 
			codeGenerationBlock value: ssaFunction value: funcletValue value: slvmBuilder value: self
		]
	] ifFalse: [
		self withDebugPosition: (codeModuleGenerator convertDebugPosition: aConcreteMethod definitionPosition asActualSourcePosition) do: [ 
			codeGenerationBlock value: ssaFunction value: slvmBuilder value: self
		]
	].

	self initializeCleanUpActionStates.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> buildSSAFunction: aSSAFunction withCodeGenerationBlock: codeGenerationBlock [
	ssaFunction := aSSAFunction.
	functionVariables := Dictionary new.
	
	self setupBuilders.

	"Generate the body code."
	codeGenerationBlock value: ssaFunction value: slvmBuilder value: self.

	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> defineArgumentValues [
	| argumentValue superVariable argIndex |
	self assert: (concreteMethod isConcreteMethod not or: [concreteMethod arguments size <= ssaFunction arguments size]).
	
	argIndex := 1.
	concreteMethod returnType isMemoryReturnedType ifTrue: [ 
		ssaFunction arguments first markStructReturnPointer.
		argIndex := argIndex + 1
	].

	concreteMethod arguments do: [ :argVariable |
		argumentValue := ssaFunction arguments at: argIndex.
		argVariable name isMbndAnonymousSymbol ifFalse: [
			argumentValue name: argVariable name
		].
	
		functionVariables at: argVariable put: argumentValue.
		
		argVariable isFunctionReceiverArgumentVariable ifTrue: [ 
			superVariable := argVariable asSuperArgumentVariable.
			superVariable type isVoidType ifFalse: [
				functionVariables at: superVariable put: argumentValue
			].
		].
	
		argIndex := argIndex + 1
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeAllScopeCleanUp [
	^ self executeAllScopeCleanUpExceptForTokens: #()
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeAllScopeCleanUpExceptForTokens: suppressedCleanUpTokens [
	| position |
	position := currentCleanUpScope.
	[ position ] whileNotNil: [
		self executeScopeCleanUpActions: position exceptForTokens: suppressedCleanUpTokens.
		slvmBuilder isLastTerminator ifTrue: [ ^ self ] .
		position := position parent
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeImplicitFinalizationAction: action [
	| activated cleanUpBlock mergeBlock |
	action finalizationActionBlocks ifEmpty: [ ^ self ].
	action isActuallyExecuted: true.

	activated := slvmBuilder load: action finalizationActivated.
	cleanUpBlock := slvmBuilder newBasicBlock: #implicitCleanUpAction.
	mergeBlock := slvmBuilder newBasicBlock: #implicitCleanUpMerge.

	self assert: slvmBuilder currentBlock mergeBlock isNil.
	slvmBuilder currentBlock mergeBlock: mergeBlock.
	slvmBuilder branch: activated ifTrue: cleanUpBlock ifFalse: mergeBlock.
	
	slvmBuilder currentBlock: cleanUpBlock.
	action finalizationActionBlocks do: #value.
	slvmBuilder isLastTerminator ifFalse: [ slvmBuilder jump: mergeBlock ].

	slvmBuilder currentBlock: mergeBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeScopeCleanUpActions: cleanUpScope [
	^ self executeScopeCleanUpActions: cleanUpScope exceptForTokens: #()
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeScopeCleanUpActions: cleanUpScope exceptForTokens: suppressedCleanUpTokens [
	cleanUpScope implicitFinalizationStateDictionary valuesDo: [ :action |
		(suppressedCleanUpTokens includes: action token) ifFalse: [ 
			self executeImplicitFinalizationAction: action
		].
	].
	cleanUpScope explicitFinalizationAction ifNotNil: [ :ac |
		ac value
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> extractColumns: columns elementAsVector: element [
	| halfSize leftHalf rightHalf leftHalfType rightHalfType returnType |
	columns size = 1 ifTrue: [
		^ slvmBuilder extractVector: columns first element: element
	].
	columns size = 2 ifTrue: [
		^ slvmBuilder shuffleVector: columns first with: columns second components: { element value . columns first type elements + element value }
	].
	
	halfSize := columns size // 2.
	leftHalf := self extractColumns: (columns first: halfSize) elementAsVector: element.
	rightHalf := self extractColumns: (columns allButFirst: halfSize) elementAsVector: element.
	leftHalfType := leftHalf type.
	rightHalfType := rightHalf type.
	returnType := SLVMVectorType baseType: (leftHalfType isVectorType
			ifTrue: [ leftHalfType baseType ]
			ifFalse: [ leftHalfType ])
		elements: columns size.
	
	^ slvmBuilder makeVector: returnType arguments: { leftHalf . rightHalf }
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticEpilogueCode [
	concreteMethod ifNil: [ ^ self ].
	(concreteMethod isMessageMethod and: [ concreteMethod name = #finalize and: [concreteMethod hasExplicitSuperSend not ]]) ifTrue: [
		self generateAutomaticFinalizationCode
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFieldFinalization: field [
	| fieldPointer fieldType finalizeMethod |

	fieldType := field valueType.
	fieldType hasTrivialFinalization ifTrue: [ ^ self ].
	
	fieldPointer := slvmBuilder getReference: ssaFunction arguments first element: (slvmBuilder constInt: field slotIndex).
	finalizeMethod := fieldType finalizeMethod.
	self generateCallWithReceiver: fieldPointer receiverType: field valueType selector: #finalize arguments: #()
		isSuperSend: false declaredMethod: finalizeMethod expectedResultType: finalizeMethod returnType
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFieldFinalizations: fields [
	fields reverseDo: [ :field | self generateAutomaticFieldFinalization: field ]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFieldInitialization: field [
	| fieldPointer fieldType initializeMethod |
	fieldType := field valueType.

	field initialValueNode ifNotNil: [ 
		self flag: 'TODO: Implement this case.'.
		self halt
	].

	fieldType hasTrivialInitialization ifTrue: [ ^ self ].
	
	fieldPointer := slvmBuilder getReference: ssaFunction arguments first element: (slvmBuilder constInt: field slotIndex).
	initializeMethod := fieldType initializeMethod.
	self generateCallWithReceiver: fieldPointer receiverType: field valueType selector: #initialize arguments: #()
		isSuperSend: false declaredMethod: initializeMethod expectedResultType: initializeMethod returnType
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFieldInitializations: fields [
	fields do: [ :field | self generateAutomaticFieldInitialization: field ]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFinalizationCode [
	| receiver superFinalize |
	receiver := ssaFunction arguments first.
	self generateAutomaticFieldFinalizations: concreteMethod parent fields.

	concreteMethod hasExplicitSuperSend ifTrue: [ ^ self ].
	
	concreteMethod parent supertype ifNotNil: [ :supertype |
		supertype hasTrivialFinalization ifFalse: [
			superFinalize := supertype finalizeMethod.
			self generateCallWithReceiver: (slvmBuilder bitCast: receiver target: (self translateType: superFinalize receiverType))
				receiverType: superFinalize receiverType
				selector: #finalize arguments: #() isSuperSend: true declaredMethod: superFinalize
				expectedResultType: superFinalize returnType
		]
	]

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticInitializationCode [
	| receiver superInitialize |
	receiver := ssaFunction arguments first.
	concreteMethod hasExplicitSuperSend ifFalse: [
		concreteMethod parent supertype ifNotNil: [ :supertype |
			supertype hasTrivialInitialization ifFalse: [
				superInitialize := supertype initializeMethod.
				self generateCallWithReceiver: (slvmBuilder bitCast: receiver target: (self translateType: superInitialize receiverType))
					receiverType: superInitialize receiverType
					selector: #initialize arguments: #() isSuperSend: true declaredMethod: superInitialize
					expectedResultType: superInitialize returnType
			]
		].
	].

	self generateAutomaticFieldInitializations: concreteMethod parent fields.
	
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticPrologueCode [
	concreteMethod ifNil: [ ^ self ].
	(concreteMethod isMessageMethod and: [ concreteMethod name = #initialize and: [concreteMethod hasExplicitSuperSend not ]]) ifTrue: [
		self generateAutomaticInitializationCode
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCall: calledFunction arguments: arguments expectedReturnType: expectedReturnType [
	| result |
	result := slvmBuilder call: calledFunction arguments: arguments.
	^ self sanitizeValue: result withExpectedType: (self translateType: expectedReturnType).
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCallWithReceiver: receiver receiverType: receiverType selector: selector arguments: arguments
isSuperSend: isSuperSend declaredMethod: declaredMethod expectedResultType: expectedResultType [
	^ self generateCallWithReceiver: receiver receiverType: receiverType selector: selector arguments: arguments
isSuperSend: isSuperSend declaredMethod: declaredMethod expectedResultType: expectedResultType at: nil
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCallWithReceiver: receiver receiverType: receiverType selector: selector arguments: arguments
isSuperSend: isSuperSend declaredMethod: declaredMethod expectedResultType: expectedResultType at: position [
	^ self generateCallWithReceiver: receiver receiverType: receiverType selector: selector arguments: arguments
isSuperSend: isSuperSend declaredMethod: declaredMethod expectedResultType: expectedResultType storageCreationNode: nil at: position
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCallWithReceiver: receiver receiverType: receiverType selector: selector arguments: arguments
isSuperSend: isSuperSend declaredMethod: declaredMethod expectedResultType: expectedResultType storageCreationNode: storageCreationNode at: position [
	| selectorValue allArguments hasDynamicMessageLookup calledMethodSSAFunction hasStaticBinding vtableLayout vtableSlot vtableEntrySlot result expectedResultSSAType actualReturnType memoryReturnTemporary |
	selectorValue := selector.
	expectedResultSSAType := self translateType: expectedResultType.
	
	isSuperSend ifTrue: [
		self generateSuperSendPrologueWithSelector: selector
	].

	hasDynamicMessageLookup := receiver
		ifNil: [ false ]
		ifNotNil: [:receiverNode | hasDynamicMessageLookup := receiverType hasDynamicMessageLookup].
	
	actualReturnType := expectedResultSSAType.
	memoryReturnTemporary := nil.
	allArguments := Array streamContents: [ :out |
		expectedResultType isMemoryReturnedType ifTrue: [
			memoryReturnTemporary := self allocateTemporaryStorageFor: expectedResultSSAType withStorageCreationNode: storageCreationNode.
			actualReturnType := SLVMType voidType.
			out nextPut: memoryReturnTemporary
		].
	
		receiver ifNotNil: [
			out nextPut: receiver
		].
		out nextPutAll: arguments
	].

	calledMethodSSAFunction := (self translateProgramEntity: declaredMethod) ssaValue.
	hasStaticBinding := declaredMethod hasPragmaNamed: #staticBinding.
	
	(declaredMethod hasVirtualTableEntry and: [ hasStaticBinding not and: [isSuperSend not]]) ifTrue: [
		hasDynamicMessageLookup := false.
		vtableLayout := receiverType slotLayout mainVirtualTable.
	
		vtableSlot := slvmBuilder load: (slvmBuilder getReference: receiver
								element: (slvmBuilder constInt: vtableLayout slotIndex)).
		vtableEntrySlot := slvmBuilder load: (slvmBuilder getPointer: vtableSlot
								element: {slvmBuilder constInt: (vtableLayout getSlotIndexFor: declaredMethod virtualTableSelector)}).
		calledMethodSSAFunction := slvmBuilder bitCast: vtableEntrySlot target: calledMethodSSAFunction type.
	].
	
	hasStaticBinding ifTrue: [ hasDynamicMessageLookup := false ].
	
	hasDynamicMessageLookup ifTrue:[
		selectorValue isSymbol ifTrue: [ selectorValue := slvmBuilder addDynamicLiteral: selectorValue ].
		self assert: selectorValue type isDynamicObjectPointerType.
		result := slvmBuilder send: selectorValue returnType: actualReturnType receiver: receiver arguments: arguments.
		isSuperSend ifTrue: [
			result setSuperSend
		].
	] ifFalse: [
		result := slvmBuilder call: calledMethodSSAFunction arguments: allArguments.
	].

	isSuperSend ifTrue: [
		self generateSuperSendEpilogueWithSelector: selector
	].

	memoryReturnTemporary ifNotNil: [
		expectedResultType hasTrivialFinalization ifFalse: [
			self addLocalVariable: memoryReturnTemporary withValueType: expectedResultType cleanUpActionForNode: position
		].
		result := memoryReturnTemporary
	] ifNil: [ 
		"We may need to adjust the result type in the case of dependent types."
		result type ~~ expectedResultSSAType ifTrue: [ 
			self assert: (result type isPointerType and: [ expectedResultSSAType isPointerType ]).
			result := slvmBuilder bitCast: result target: expectedResultSSAType
		].
	].

	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCase: case withMatchedValue: matchedValue [
	case bindings ifNotEmpty: [
		self generateDestructuringPattern: case pattern assignment: matchedValue
	].
	^ self visitNode: case action
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCasesOfNode: node matchedValue: matchedValue caseStream: caseStream [
	| currentCase mergeValue caseValue |
	currentCase := caseStream peek.
	mergeValue := nil.
	matchedValue type isIntegerType ifTrue: [
		| literalCases |
		literalCases := Array streamContents: [ :out |
			[ currentCase isNotNil and: [ currentCase pattern isPatternMatchingLiteralValuePatternNode] ] whileTrue: [ 
				out nextPut: caseStream next.
				currentCase := caseStream peek.
			]
		].
	
		literalCases ifNotEmpty: [
			| caseConstants caseBlocks defaultBlock mergeBlock switchBlock |
			caseConstants := literalCases collect: [ :case | self visitNode: case pattern ].
			caseBlocks := literalCases collect: [ :case | slvmBuilder newBasicBlock: #casesOfCase ].
			defaultBlock := slvmBuilder newBasicBlock: #casesOfDefault.
			mergeBlock := slvmBuilder newBasicBlock: #casesOfMerge.

			switchBlock := slvmBuilder currentBlock.
			slvmBuilder currentBlock mergeBlock: mergeBlock.
			slvmBuilder switch: matchedValue caseConstants: caseConstants caseBlocks: caseBlocks defaultBlock: defaultBlock.
			node type isVoidType ifFalse: [
				slvmBuilder currentBlock: mergeBlock.
				mergeValue := slvmBuilder phi: (self translateType: node type) name: #casesResult
			].

			"Generate the literal cases."
			literalCases doWithIndex: [ :case :index |
				slvmBuilder currentBlock: (caseBlocks at: index).
				caseValue := self generateCase: case withMatchedValue: matchedValue.
				slvmBuilder isLastTerminator ifFalse: [
					mergeValue ifNotNil: [
						mergeValue addValue: caseValue from: slvmBuilder currentBlock.
					].
					slvmBuilder jump: mergeBlock
				]
			].
		
			"Generate the default case."
			slvmBuilder currentBlock: defaultBlock.
			caseValue := self generateCasesOfNode: node matchedValue: matchedValue caseStream: caseStream.

			slvmBuilder isLastTerminator ifFalse: [
				mergeValue ifNotNil: [
					mergeValue addValue: caseValue from: slvmBuilder currentBlock.
				].
				slvmBuilder jump: mergeBlock
			].

			"Move back to the merge block."		
			slvmBuilder currentBlock: mergeBlock.
			mergeBlock predecessors ifEmpty: [
				slvmBuilder unreachable.
				switchBlock addUnreachableStructuredSuccessors.
				mergeValue ifNotNil: [ mergeValue removeFromBlock ].
				^ nil
			].
			
			^ mergeValue
		]
	].

	currentCase ifNil: [ ^ self translateLiteralValue: node type defaultValue ].
	currentCase hasDefaultPattern ifTrue: [
		^ self generateCase: currentCase withMatchedValue: matchedValue
	].

	self halt
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCleanUpActionActivatedHereForNode: node token: token with: aBlock [
	| cleanUpActionState activatedFlag |
	self assert: currentCleanUpScope isNotNil.
	self assert: (currentCleanUpScope allowedNodesWithImplicitFinalization includes: node).
	cleanUpActionState := currentCleanUpScope implicitFinalizationStateDictionary at: token ifAbsentPut: [
		implicitCleanUpActionStates add: (MbndSlovimCleanUpScopeImplicitFinalizationState new
			token: token;
			yourself)
	].
	
	cleanUpActionState finalizationActivated ifNil: [
		activatedFlag := slvmBuilder allocaBuilder alloca: SLVMType boolType.
		cleanUpActionState finalizationActivated: activatedFlag.
		slvmBuilder store: (slvmBuilder constBool: true) in: activatedFlag.
	].
	cleanUpActionState addFinalizationActionBlock: aBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateDestructuringPattern: pattern assignment: assignmentValue [
	^ MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator new
		functionCodeGenerator: self;
		assignmentValue: assignmentValue;
		visitNode: pattern
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateExpandedMessageSendNode: node withDeclaredMethod: declaredMethod [
	"Process the receiver."
	| receiver isSuperSend selectorValue arguments receiverType |
	receiver := node receiver ifNotNil: [self visitNode: node receiver].
	isSuperSend := false.
	(node receiver isNotNil and: [ node receiver isSuperReference ]) ifTrue: [
		isSuperSend := true.
	].

	"Process the selector and the remaining arguments."
	selectorValue := self visitNode: node selector.
	arguments := self visitNodesAndCollect: node arguments.
	receiverType := node receiver ifNil: [ self compilationTarget voidType ]
		ifNotNil: [ node receiver type ].
	^ self generateCallWithReceiver: receiver receiverType: receiverType withoutReferences selector: selectorValue arguments: arguments
		isSuperSend: isSuperSend declaredMethod: declaredMethod expectedResultType: node methodReturnType
		storageCreationNode: node storageCreationNode
		at: node
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateExpandedMessageSendNode: node withIntrinsicName: intrinsicName [
	| intrinsicSSAFunction receiver arguments allArguments |
	AdditionalIntrinsicsDictionary at: intrinsicName ifPresent: [ :selector |
		^ self perform: selector with: node
	].
	(EvaluationOnlyIntrinsics includes: intrinsicName) ifTrue: [
		^ self generateExpandedMessageSendNode: node withDeclaredMethod: node method
	].

	receiver := node receiver ifNil: [#()]
		ifNotNil: [{self visitNode: node receiver}].
	arguments := self visitNodesAndCollect: node arguments.
	allArguments := receiver , arguments.
	allArguments := self processIntrinsic: intrinsicName callArguments: allArguments.

	intrinsicSSAFunction := codeModuleGenerator intrinsicConstantBuiltInFunction:
		(IntrinsicTargetMap at: intrinsicName ifAbsent: [ intrinsicName ])
		withType: node method type.

	^ self generateCall: intrinsicSSAFunction arguments: allArguments expectedReturnType: node type

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateFuncletValue: funclet withArguments: funcletArguments [
	^ self withConcreteMethod: funclet do: [ 
		funcletArguments doWithIndex: [ 
			self halt.
		].
	
		self visitNode: funclet analyzedBody
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateIdentityEquals: node [
	| leftValue rightValue |
	leftValue := self visitNode: node receiver.
	rightValue := self visitNode: node arguments first.
	self assert: leftValue type isDynamicObjectPointerType.
	self assert: rightValue type isDynamicObjectPointerType.
	self assert: leftValue type == rightValue type.
	^ slvmBuilder dynObjectIdentityEquals: leftValue with: rightValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateIdentityNotEquals: node [
	| leftValue rightValue |
	leftValue := self visitNode: node receiver.
	rightValue := self visitNode: node arguments first.
	self assert: leftValue type isDynamicObjectPointerType.
	self assert: rightValue type isDynamicObjectPointerType.
	self assert: leftValue type == rightValue type.
	^ slvmBuilder dynObjectIdentityNotEquals: leftValue with: rightValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateLocalVariable: localVariable definitionAt: position withInitialValue: initialValueBlock initialValueKind: initialValueKind [
	^ self generateLocalVariable: localVariable storageCreationNode: nil definitionAt: position withInitialValue: initialValueBlock initialValueKind: initialValueKind
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateLocalVariable: localVariable storageCreationNode: storageCreationNode definitionAt: position withInitialValue: initialValueBlock initialValueKind: initialValueKind [
	| valueType initialValue ssaValue |
	self assert: (functionVariables includesKey: localVariable) not.
	self assert: initialValueBlock isNotNil.

	valueType := self translateType: localVariable valueType.
	
	(localVariable type isReferenceType or: [ localVariable type isTemporaryReferenceType ]) ifTrue: [
		(localVariable valueType isReferenceType or: [localVariable valueType isTemporaryReferenceType]) ifTrue: [
			initialValue := initialValueBlock value.
			self assert: initialValue isNotNil.
			self assert: initialValue type isPointerType.
			ssaValue := initialValue.

			self isEmittingDebugInformation ifTrue: [ 
				localVariable name isMbndGenerateSymbolRemovedFromDebug ifFalse: [
					(slvmBuilder debugSetVariable: (self translateProgramEntityDebugInformation: localVariable) value: ssaValue)
				]
			].
		] ifFalse: [
			ssaValue := self allocateTemporaryStorageFor: valueType withStorageCreationNode: storageCreationNode.
			(storageCreationNode isNil and: [position isMbndAstNode]) ifTrue: [
				self setStorageCreationNode: position variableForCopyEllision: ssaValue
			].
		
			initialValue := initialValueBlock value.
		
			self generateVariable: ssaValue withValueType: localVariable valueType initializationWithValue: initialValue initialValueKind: initialValueKind.

			self isEmittingDebugInformation ifTrue: [ 
				localVariable name isMbndGenerateSymbolRemovedFromDebug ifFalse: [
					(slvmBuilder debugDeclareVariable: ssaValue)
						debugInformation: (self translateProgramEntityDebugInformation: localVariable)
				]
			].
		
			localVariable valueType hasTrivialFinalization ifFalse: [
				initialValue ~~ ssaValue ifTrue: [
					"Avoid double finalization."
					self addLocalVariable: ssaValue withValueType: localVariable valueType cleanUpActionForNode: position
				].
			].
		].
	] ifFalse: [
		initialValue := initialValueBlock value.
		ssaValue := initialValue.

		self isEmittingDebugInformation ifTrue: [ 
			localVariable name isMbndGenerateSymbolRemovedFromDebug ifFalse: [
				(slvmBuilder debugSetVariable: (self translateProgramEntityDebugInformation: localVariable) value: ssaValue)
			]
		].
	].

	functionVariables at: localVariable put: ssaValue.
	^ ssaValue
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateMethodBodyForIntrinsic: intrinsicName [
	| ssaBuiltIn result processedArguments |
	(AdditionalIntrinsicsDictionary includesKey: intrinsicName) ifTrue: [ ^ false ].
	(EvaluationOnlyIntrinsics includes: intrinsicName) ifTrue: [ ^ false ].
	slvmBuilder := SLVMBuilder on: ssaFunction.
	slvmBuilder newBasicBlockHere: #intrinsic.

	processedArguments := self processIntrinsic: intrinsicName callArguments: ssaFunction arguments asArray.
	ssaBuiltIn := codeModuleGenerator intrinsicConstantBuiltInFunction: (IntrinsicTargetMap at: intrinsicName ifAbsent: [ intrinsicName ]) withType: concreteMethod type.
	
	result := self generateCall: ssaBuiltIn arguments: processedArguments expectedReturnType: concreteMethod returnType.

	result type isVoidType ifTrue: [ 
		slvmBuilder returnVoid
	] ifFalse: [ 
		slvmBuilder return: result
	].
	^ true
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateSuperSendEpilogueWithSelector: selector [
	selector isSymbol ifFalse: [ ^ self ].
	concreteMethod hasExplicitSuperSend ifFalse: [ ^ self ].

	(concreteMethod isConcreteMethod and: [ concreteMethod isMessageMethod and: [ concreteMethod name = selector ] ]) ifTrue: [ 
		selector = #initialize ifTrue: [ self generateAutomaticInitializationCode ]
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateSuperSendPrologueWithSelector: selector [
	selector isSymbol ifFalse: [ ^ self ].
	concreteMethod hasExplicitSuperSend ifFalse: [ ^ self ].
	(concreteMethod isConcreteMethod and: [ concreteMethod isMessageMethod and: [ concreteMethod name = selector ] ]) ifTrue: [ 
		selector = #finalize ifTrue: [ self generateAutomaticFinalizationCode ]
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateVariable: ssaValue basicInitializationWithValueType: valueType [
	slvmBuilder store: (self translateLiteralValue: valueType defaultValue) in: ssaValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateVariable: variable finalizationForValueType: valueType [
	slvmBuilder call: (self translateProgramEntity: valueType finalizeMethod) ssaValue arguments: { variable }
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateVariable: ssaValue withValueType: valueType initializationWithValue: initialValue initialValueKind: initialValueKind [
	| initialLoadedValue |
	self assert: initialValueKind isNotNil.
	
	initialValueKind = #default ifTrue: [ 
		slvmBuilder store: (self sanitizeStoreValue: initialValue inPointer: ssaValue) in: ssaValue.
		valueType hasTrivialInitialization ifFalse: [
			slvmBuilder call: (self translateProgramEntity: valueType initializeMethod) ssaValue arguments: {ssaValue}
		].
		^ self
	].

	initialValueKind = #copy ifTrue: [
		valueType isTypePassedByReference ifTrue: [
			"Copy ellision nop."
			initialValue == ssaValue ifTrue: [ ^ self ].
		].

		valueType hasTrivialInitializationFromCopy ifTrue: [
			initialLoadedValue := initialValue.
			valueType isTypePassedByReference ifTrue: [
				self assert: initialLoadedValue type isPointerType.
				self assert: initialLoadedValue type ~= ssaValue type baseType.
				initialLoadedValue := slvmBuilder load: initialLoadedValue.
			].
			slvmBuilder store: (self sanitizeStoreValue: initialLoadedValue inPointer: ssaValue) in: ssaValue.
		] ifFalse: [
			self generateVariable: ssaValue basicInitializationWithValueType: valueType.
			self assert: initialValue type isPointerType.
			slvmBuilder call: (self translateProgramEntity: valueType initializeFromCopyMethod) ssaValue arguments: {ssaValue . initialValue}
		].
		^ self
	].

	initialValueKind = #move ifTrue: [ 
		valueType isTypePassedByReference ifTrue: [
			"Copy ellision nop."
			initialValue == ssaValue ifTrue: [ ^ self ].
		].

		valueType hasTrivialInitializationMovingFrom ifTrue: [
			^ self generateVariable: ssaValue withValueType: valueType initializationWithValue: initialValue initialValueKind: #copy
		] ifFalse: [
			self generateVariable: ssaValue basicInitializationWithValueType: valueType.
			self assert: initialValue type isPointerType.
			slvmBuilder call: (self translateProgramEntity: valueType initializeMovingFromMethod) ssaValue arguments: {ssaValue . initialValue}
		].
		^ self
	].

	self error: 'Unsupported variable kind of initialization.'
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateVectorCross2DIntrinsic: node [
	| leftVector rightVector vectorType leftOperand rightOperand multiplication leftProduct rightProduct |
	leftVector := self visitNode: node receiver.
	rightVector := self visitNode: node arguments first.
	self assert: leftVector type = rightVector type.
	vectorType := leftVector type. 
	self assert: vectorType elements = 2.
	
	leftOperand := slvmBuilder shuffleVector: leftVector with: rightVector components: #(0 3).
	rightOperand := slvmBuilder shuffleVector: leftVector with: rightVector components: #(2 1).
	multiplication := slvmBuilder vectorMul: leftOperand with: rightOperand.
	leftProduct := slvmBuilder extractVector: multiplication element: (slvmBuilder constInt: 0).
	rightProduct := slvmBuilder extractVector: multiplication element: (slvmBuilder constInt: 1).
	^ vectorType baseType isFloatType ifTrue: [ 
		slvmBuilder fadd: leftProduct with: rightProduct
	] ifFalse: [ 
		slvmBuilder add: leftProduct with: rightProduct
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateVectorLength2Intrinsic: node [
	| vector |
	vector := self visitNode: node receiver.
	^ slvmBuilder vectorDot: vector with: vector
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> initializeArgumentVariable: argument [
	| debugInformation convertedPosition ssaValue |

	self isEmittingDebugInformation ifTrue: [ 
		argument name isMbndAnonymousSymbol ifFalse: [ 
			debugInformation := self translateProgramEntityDebugInformation: argument.
			convertedPosition := codeModuleGenerator convertDebugPosition: argument definitionPosition asActualSourcePosition.
			ssaValue := functionVariables at: argument.
			ssaValue
				debugInformation: debugInformation;
				debugSourceLocation: convertedPosition.
			
			(slvmBuilder debugSetVariable: debugInformation value: ssaValue)
				debugSourceLocation: convertedPosition
		].
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> initializeArgumentVariables [
	concreteMethod arguments do: [ :argument |
		self initializeArgumentVariable: argument
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> initializeCleanUpActionStates [
	implicitCleanUpActionStates do: [ :cleanUpState |
		cleanUpState finalizationActivated ifNotNil: [ :activatedFlag |
			cleanUpState isActuallyExecuted ifTrue: [ 
				slvmBuilder allocaBuilder store: (slvmBuilder constBool: false) in: activatedFlag.
			] ifFalse: [
				"Remove any reference to an unused clean-up action state."
				activatedFlag instructionReferences do: [ :ref |
					self assert: ref isStore.
					ref removeFromBlock.
				].
				activatedFlag removeFromBlock
			].
		].
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> processIntrinsic: intrinsicName callArguments: callArguments [
	| processedArguments |
	processedArguments := callArguments.
	(intrinsicName beginsWith: 'atomic.') ifTrue: [
		self assert: callArguments first type isPointerType.
		self assert: callArguments first type baseType isStructureType.
		processedArguments := {slvmBuilder getReference: callArguments first element: (slvmBuilder constInt: 0)} , callArguments allButFirst.
	].

	^ processedArguments
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> replaceVector: vector elements: elementIndices with: newValues [
	| result |
	self assert: elementIndices size = newValues size.
	result := vector.
	1 to: elementIndices size do: [ :i |
		| value elementIndex |
		value := newValues at: i.
		elementIndex := elementIndices at: i.
		result := slvmBuilder insertVector: result element: (slvmBuilder constInt: elementIndex) value: value
	].
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> sanitizeStoreValue: value inPointer: fieldPointer [
	self assert: fieldPointer type isPointerType.
	^ self sanitizeValue: value withExpectedType: fieldPointer type baseType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> sanitizeValue: value withExpectedType: expectedType [
	self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [ 
		(expectedType isBooleanType and: [ value type isIntegerType ]) ifTrue: [ 
			^ slvmBuilder truncate: value target: self slvmCompilationTarget bool
		].
	
		(expectedType isIntegerType and: [ value type isBooleanType ]) ifTrue: [ 
			^ slvmBuilder zeroExtend: value target: expectedType
		].
	].

	^ value
]

{ #category : #initialization }
MbndSlovimFunctionCodeGenerator >> setStorageCreationNode: node variableForCopyEllision: ssaVariable [
	storageCreationNodeVariableMapForCopyEllision at: node put: ssaVariable
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> setupBuilders [
	"Create the main slvm builder."	
	| initialDebugPosition |
	slvmBuilder := SLVMBuilder on: ssaFunction.
	ssaFunctionEntryBlock := slvmBuilder newBasicBlockHere: #entry.
	implicitCleanUpActionStates := OrderedCollection new.
	storageCreationNodeVariableMapForCopyEllision := IdentityDictionary new.

	"Create the alloca builder."
	slvmBuilder allocaBuilder: ((SLVMBuilder on: ssaFunction)
		currentBlock: ssaFunctionEntryBlock).

	"Create the body block."	
	ssaFunctionBodyBlock := slvmBuilder newBasicBlockHere: #body.
	
	self isEmittingDebugInformation ifTrue: [
		concreteMethod ifNotNil: [ 
			initialDebugPosition := codeModuleGenerator convertDebugPosition: concreteMethod definitionPosition asActualSourcePosition scope: nil.
			slvmBuilder pushDebugSourcePosition: initialDebugPosition.
	slvmBuilder allocaBuilder pushDebugSourcePosition: initialDebugPosition.
		]
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> setupSSAFunction: aSSAFunction definitionWithMethod: aConcreteMethod [
	ssaFunction := aSSAFunction.
	concreteMethod := aConcreteMethod.
	functionVariables := Dictionary new.
	
	concreteMethod isConcreteMethod ifTrue: [ 
		self assert: concreteMethod analyzedBody isNotNil.
	
		concreteMethod pragmaAt: #intrinsic: ifPresent: [ :pragma |
			(self generateMethodBodyForIntrinsic: pragma arguments first value) ifTrue: [ ^ true ]
		].
	].
	
	"Define the argument values."
	self defineArgumentValues.

	self setupBuilders.
	
	"Initialize the argument variables."
	self initializeArgumentVariables.
	
	^ false
]

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> slvmBuilder [
	^ slvmBuilder
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> storeValueInTemporary: value [
	| temporary |
	temporary := slvmBuilder allocaBuilder alloca: value type.
	slvmBuilder store: value in: temporary.
	^ temporary
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> translateLiteralValue: value [
	^ codeModuleGenerator translateLiteralValue: value value ofType: value type
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitArrayElementReferenceNode: node [
	| pointer index |
	pointer := self visitNode: node container.
	index := self visitNode: node index.
	self assert: index type isIntegerType.
	"Convert one based indices into zero based indices."
	node isOneBasedIndex ifTrue: [ 
		index := slvmBuilder sub: index with: (SLVMConstant type: index type value: 1)
	].

	^ slvmBuilder getReference: pointer element: index
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitAssignmentNode: node [
	| value reference |
	value := self visitNode: node value.
	reference := self visitNode: node reference.
	
	node value type isTypePassedByReference ifTrue: [ 
		self assert: value type isPointerType.
		self assert: value type ~= reference type baseType.
		value := slvmBuilder load: value
	].

	(slvmBuilder store: (self sanitizeStoreValue: value inPointer: reference) in: reference)
		volatile: node reference type isVolatileType.
		
	self assert: node type isReferenceType.
	^ reference
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitBitCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder bitCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitBlockClosureNode: node [
	self assert: node isBlockClosureWithImmediateActivation not.
	self halt
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitBooleanToDynamicObjectCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder boolToDynamicObjectCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitCasesOfNode: node [
	| matchedValue literalGroupStream |
	matchedValue := self visitNode: node matchedExpression.
	literalGroupStream := node cases readStream.
	^ self generateCasesOfNode: node matchedValue: matchedValue caseStream: literalGroupStream
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitCharacterToDynamicObjectCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder charToDynamicObjectCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitCleanUpScopeNode: node [
	| cleanUpScope resultTemporary resultValue resultImplicitFinalization |
	cleanUpScope := MbndSlovimCleanUpScope new parent: currentCleanUpScope.
	cleanUpScope allowedNodesWithImplicitFinalization: node nodesWithImplicitFinalization.

	node explicitCleanUpActions ifNotEmpty: [ 
		cleanUpScope explicitFinalizationAction: [
			node explicitCleanUpActions do: [ :cleanUpAction | self visitNode: cleanUpAction ]
		].
	].

	resultTemporary := nil.
	resultImplicitFinalization := nil.
	self withCleanUpScope: cleanUpScope do: [ 
		resultValue := self visitNode: node expression.
		(resultValue isNotNil and: [node type isVoidType not]) ifTrue: [ 
			"If the result value has an implicit finalization, we may be able to delay its finalization."
			cleanUpScope implicitFinalizationStateDictionary at: resultValue asCanonicalLocalReference ifPresent: [ :finalizationAction |
				resultImplicitFinalization := finalizationAction.
				cleanUpScope implicitFinalizationStateDictionary removeKey: finalizationAction token
			] ifAbsent: [
				node type hasTrivialFinalization ifFalse: [
					self assert: node type isMemoryReturnedType.
					resultTemporary := slvmBuilder allocaBuilder alloca: (self translateType: node type).
					self generateVariable: resultTemporary withValueType: node type initializationWithValue: resultValue initialValueKind: #move.
				].
			].
		].
	].

	currentCleanUpScope ifNotNil: [
		"Delay the implicit finalization of the result by lifting it up to the outer finalization scope."
		resultImplicitFinalization ifNotNil: [
			currentCleanUpScope implicitFinalizationStateDictionary at: resultImplicitFinalization token ifPresent: [ :previous |
				self error: 'Local variable with multiple finalization contexts.'
			] ifAbsentPut: [ resultImplicitFinalization ]
		].
	
		resultTemporary ifNotNil: [ 
			self addLocalVariable: resultTemporary withValueType: node type cleanUpActionForNode: node.
		].
	].

	^ resultValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitConcretizeUndefinedValueCastNode: node [
	"Visit the node for the side effects."
	| defaultValue |
	self visitNode: node expression.

	defaultValue := node type defaultValue.
	^ codeModuleGenerator translateLiteralValue: defaultValue value ofType: defaultValue type
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDecorationChangeTypeCastNode: node [
	| source |
	source := self visitNode: node expression.
	^ source
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDoWhileLoopNode: node [
	| loopHeader loopBody loopContinue loopMerge loopCondition |
	loopHeader := slvmBuilder newBasicBlock: #doWhileHeader.
	loopBody := slvmBuilder newBasicBlock: #doWhileBody.
	loopCondition := slvmBuilder newBasicBlock: #doWhileCondition.
	loopContinue := node continueAction
		ifNil: [ loopCondition ]
		ifNotNil: [ slvmBuilder newBasicBlock: #doWhileContinue ].
	loopMerge := slvmBuilder newBasicBlock: #doWhileMerge.
	
	"Enter into the loop."
	slvmBuilder
		jump: loopHeader;
		currentBlock: loopHeader.
		
	"Set the structured blocks."
	loopHeader
		continueBlock: loopContinue;
		mergeBlock: loopMerge.
		
	"Enter the loop body"
	slvmBuilder jump: loopBody.
	
	"Generate the loop body."
	slvmBuilder currentBlock: loopBody.
	node action ifNotNil: [ :action |
		self withBreakBlock: loopMerge continueBlock: loopContinue do: [ 
			self visitNode: action
		]
	].

	slvmBuilder isLastTerminator ifFalse: [ 
		slvmBuilder jump: loopContinue
	].

	"Generate the continue action"
	node continueAction ifNotNil: [ :action |
		slvmBuilder currentBlock: loopContinue.

		self visitNode: action.

		slvmBuilder isLastTerminator ifFalse: [
			slvmBuilder jump: loopCondition
		]
	].

	"Test the loop condition."
	slvmBuilder currentBlock: loopCondition.
	node condition ifNil: [
		slvmBuilder jump: loopHeader.
	] ifNotNil: [ :expr |
		slvmBuilder branch: (self visitNode: expr) ifTrue: loopHeader ifFalse: loopMerge
	].

	slvmBuilder currentBlock: loopMerge.
	loopMerge predecessors ifEmpty: [
		loopHeader addUnreachableStructuredSuccessors.
		slvmBuilder unreachable.
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDynamicObjectToBooleanCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder dynamicObjectToBoolCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDynamicObjectToCharacterCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder dynamicObjectToCharCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDynamicObjectToFloatCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder dynamicObjectToFloatCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDynamicObjectToIntegerCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder dynamicObjectToIntCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitExpandScalarToMatrixCastNode: node [
	| scalar matrixType  columnType zeroConstant |
	scalar := self visitNode: node expression.
	matrixType := self translateType: node type.

	columnType := matrixType columnType.
	zeroConstant := matrixType baseType defaultConstant.
	^ slvmBuilder makeMatrix: matrixType arguments: ((0 to: matrixType columns - 1) collect: [ :columnIndex |
		slvmBuilder makeVector: columnType arguments: ((0 to: matrixType rows - 1) collect: [ :rowIndex |
			columnIndex = rowIndex
				ifTrue: [ scalar ]
				ifFalse: [ zeroConstant ]
			
		])
	])
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitExpandScalarToVectorCastNode: node [
	| scalar vectorType |
	scalar := self visitNode: node expression.
	vectorType := self translateType: node type.
	^ slvmBuilder makeVector: vectorType arguments: ((1 to: vectorType elements) collect: [ :i | scalar ])
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitExpandedDynamicMessageSendNode: node [
	| receiver selector arguments returnType sendInstruction |
	receiver := self visitNode: node receiver.
	selector := self visitNode: node selector.
	arguments := self visitNodesAndCollect: node arguments.
	returnType := self translateType: node type.
	sendInstruction := slvmBuilder send: selector returnType: returnType receiver: receiver arguments: arguments.
	node receiver isSuperReference ifTrue: [ 
		sendInstruction setSuperSend
	].
	^ sendInstruction
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitExpandedMessageSendNode: node [
	| methodProgramEntity |
	self assert: node method isNotNil.
	methodProgramEntity := self translateProgramEntity: node method.
	^ methodProgramEntity generateExpandedMessageSendNode: node with: self
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitFloatToDynamicObjectCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder floatToDynamicObjectCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitFloatingPointSizeCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder floatingPointCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitFloatingPointToIntegerCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder floatToIntCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitFunctionCallNode: node [
	| functionValue argumentValues intrinsicName memoryReturnTemporary expectedResultSSAType result expectedResultType |
	functionValue := nil.
	node function isMethodReferenceNode ifTrue: [ 
		node function binding pragmaAt: #intrinsic: ifPresent: [ :pragma |
			intrinsicName := pragma arguments first value.
			(EvaluationOnlyIntrinsics includes: intrinsicName) ifFalse: [
				functionValue := codeModuleGenerator intrinsicConstantBuiltInFunction: (IntrinsicTargetMap at: intrinsicName ifAbsent: [ intrinsicName ]) withType: node function binding type.
			].
		].
	].

	functionValue ifNil: [ functionValue := self visitNode: node function ].
	
	expectedResultType := node functionReturnType.
	expectedResultSSAType := self translateType: expectedResultType.
	memoryReturnTemporary := nil.
	argumentValues := Array streamContents: [:out |
		expectedResultType isMemoryReturnedType ifTrue: [ 
			memoryReturnTemporary := self allocateTemporaryStorageFor: expectedResultSSAType withStorageCreationNode: node storageCreationNode.
			out nextPut: memoryReturnTemporary
		].

		node arguments do: [:arg |
			out nextPut: (self visitNode: arg)
		].
	].

	result := slvmBuilder call: functionValue arguments: argumentValues.
	
	memoryReturnTemporary ifNotNil: [
		expectedResultType hasTrivialFinalization ifFalse: [
			self addLocalVariable: memoryReturnTemporary withValueType: expectedResultType cleanUpActionForNode: node
		].
		result := memoryReturnTemporary
	] ifNil: [
		"We may need to adjust the result type in the case of dependent types."
		result type ~~ expectedResultSSAType ifTrue: [ 
			self assert: (result type isPointerType and: [ expectedResultSSAType isPointerType ]).
			result := slvmBuilder bitCast: result target: expectedResultSSAType
		].
	].
	
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitGCVariableDataArrayElementReferenceNode: node [
	| pointer index |
	pointer := self visitNode: node container.
	index := self visitNode: node index.
	self assert: index type isIntegerType.
	"Convert one based indices into zero based indices."
	node isOneBasedIndex ifTrue: [ 
		index := slvmBuilder sub: index with: (SLVMConstant type: index type value: 1)
	].

	^ slvmBuilder getReference: pointer element: index
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitGetFieldReferenceNode: node [
	| aggregate field aggregateType |
	aggregate := self visitNode: node aggregate.
	(self aggregate: node aggregate value: aggregate getFieldOverrideFor: node field) ifNotNil: [ :fieldOverride |
		^ fieldOverride
	].
	self assert: aggregate type isPointerType.
	
	aggregateType := node aggregate type withoutDecorations withoutReferences.
	field := node field.
	self assert: field bits isNil.
	aggregateType isUnionType ifTrue: [
		^ slvmBuilder bitCast: aggregate target: (self translateType: node type)
	].

	^ slvmBuilder getReference: aggregate element: (slvmBuilder constInt: field slotIndex).


]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitGetFieldValueNode: node [
	| aggregate field aggregateType fieldValue |
	aggregate := self visitNode: node aggregate.
	aggregateType := node aggregate type withoutDecorations withoutReferences.
	field := node field.
	
	aggregateType isUnionType ifTrue: [ 
		aggregate type isPointerType ifFalse: [ 
			aggregate := self storeValueInTemporary: aggregate
		].
	].
	
	aggregate type isPointerType ifTrue: [
		aggregateType isUnionType ifTrue: [ 
			fieldValue := slvmBuilder load: (slvmBuilder bitCast: aggregate target: (slvmBuilder pointerTypeFor: (self translateType: field valueType)))
		] ifFalse: [
			fieldValue := slvmBuilder load: (slvmBuilder getReference: aggregate element: (slvmBuilder constInt: field slotIndex))
		].
	] ifFalse: [
		fieldValue := slvmBuilder extractValue: aggregate indices: { field slotIndex }.
	].

	field bits ifNotNil: [
		| valueType |
		valueType := self translateType: field valueType.
		fieldValue := slvmBuilder bitAnd: fieldValue with: (slvmBuilder const: field bitMask type: valueType).
		fieldValue := slvmBuilder shiftRight: fieldValue with: (slvmBuilder const: field bitOffset type: valueType).
	].

	^ self sanitizeValue: fieldValue withExpectedType: (self translateType: node type)
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIOChannelReceiveAction: node [
	| channel messageType |
	channel := self visitNode: node channel.
	messageType := self translateType: node channel type messageType.
	
	self slvmCompilationTarget isGPU ifTrue: [
		^ slvmBuilder load: channel
	].
	
	codeModuleGenerator compilationTarget inputChannelImplementationType ifNotNil: [ :implType |
		self halt
	].

	self assert: channel type isDynamicObjectPointerType.
	^ slvmBuilder send: (slvmBuilder addDynamicLiteral: #receive) returnType: messageType receiver: channel arguments: #()
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIOChannelSendAction: node [
	| channel message |
	channel := self visitNode: node channel.
	message := self visitNode: node message.
	
	self slvmCompilationTarget isSpirV ifTrue: [ 
		slvmBuilder store: message in: channel.
		^ channel
	].

	codeModuleGenerator compilationTarget outputChannelImplementationType ifNotNil: [ :implType |
		self halt
	].

	self assert: channel type isDynamicObjectPointerType.
	slvmBuilder send: (slvmBuilder addDynamicLiteral: #send:) returnType: channel type receiver: channel arguments: { message }.
	^ channel
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIfConditionNode: node [
	| condition mergeBlock thenBlock elseBlock trueResult falseResult hasTrueResult hasFalseResult resultType branchBlock |
	condition := self visitNode: node condition.
	thenBlock := node trueValue ifNotNil: [slvmBuilder newBasicBlock: #ifThen ].
	elseBlock := node falseValue ifNotNil: [slvmBuilder newBasicBlock: #ifElse].
	mergeBlock := slvmBuilder newBasicBlock: #ifMerge.
	thenBlock ifNil: [ thenBlock := mergeBlock ].
	elseBlock ifNil: [ elseBlock := mergeBlock ].
		
	branchBlock := slvmBuilder currentBlock.
	branchBlock mergeBlock: mergeBlock.
	slvmBuilder branch: condition ifTrue: thenBlock ifFalse: elseBlock.
	
	trueResult := nil.
	hasTrueResult := false.
	node trueValue ifNotNil: [
		slvmBuilder currentBlock: thenBlock.
		trueResult := self visitNode: node trueValue.
		slvmBuilder isLastTerminator ifFalse: [ 
			hasTrueResult := true.
			thenBlock := slvmBuilder currentBlock.
			slvmBuilder jump: mergeBlock.
		]
	].

	falseResult := nil.
	hasFalseResult := false.
	node falseValue ifNotNil: [
		slvmBuilder currentBlock: elseBlock.
		falseResult := self visitNode: node falseValue.
		slvmBuilder isLastTerminator ifFalse: [ 
			elseBlock := slvmBuilder currentBlock.
			slvmBuilder jump: mergeBlock.
			hasFalseResult := true.
		]
	].

	resultType := node type.

	"Enter the merge block."
	slvmBuilder currentBlock: mergeBlock.
	
	mergeBlock predecessors ifEmpty: [ 
		self assert: hasFalseResult not.
		self assert: hasTrueResult not.
		self assert: resultType isReturnType.
		slvmBuilder unreachable.
		branchBlock addUnreachableStructuredSuccessors.
		^ nil
	].

	"Do we emit a result?"
	(resultType isVoidType or: [ resultType isUndefinedType ]) ifTrue: [
		^ nil
	].

	"Do we have to merge the results?"
	(hasTrueResult and: [ hasFalseResult ]) ifTrue: [
		^ (slvmBuilder phi: (self translateType: resultType) name: #ifResult)
			addValue: trueResult from: thenBlock;
			addValue: falseResult from: elseBlock;
			yourself
	].

	hasTrueResult ifTrue: [
		self assert: hasFalseResult not.
		^ trueResult
	].

	hasFalseResult ifTrue: [
		self assert: hasTrueResult not.
		^ falseResult
	].

	self error: 'Should not reach here.'

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitImmediateBlockClosureActivationNode: node [
	| argumentValues blockProgramEntity |
	argumentValues := self visitNodesAndCollect: node arguments.
	blockProgramEntity := node blockNode blockClosureProgramEntity.
	self assert: blockProgramEntity isBlockClosureWithImmediateActivation.
	
	"Set the block closure argument values."
	blockProgramEntity arguments doWithIndex: [ :argumentVariable :index |
		functionVariables at: argumentVariable put: (argumentValues at: index)
	].
	
	"Generate the block closure body"
	^ self visitNode: node blockNode body
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIntegerToDynamicObjectCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder intToDynamicObjectCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIntegerToFloatingPointCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder intToFloatCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIntegerToPointerCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder intToPointerCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitLexicalScopeNode: node [
	^ self withLexicalScope: node lexicalScope do: [
		self visitCleanUpScopeNode: node
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitLiteralValueNode: node [
	node type isGCClassType ifTrue: [
		| dynamicLiteral |
		dynamicLiteral := slvmBuilder addDynamicLiteral: node value.
		^ slvmBuilder bitCast: dynamicLiteral target: (self translateType: node type)
	].
	^ codeModuleGenerator translateLiteralValue: node value ofType: node type
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitLocalVariableDefinitionNode: node [
	self assert: node initialValue isNotNil.
	^ self generateLocalVariable: node binding storageCreationNode: node storageCreationNode definitionAt: node withInitialValue: [self visitNode: node initialValue] initialValueKind: node initialValueKind
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMatrixConstructionNode: node [
	| columns targetType |
	columns := self visitNodesAndCollect: node columns.
	targetType := self translateType: node type.
	^ slvmBuilder makeMatrix: targetType arguments: columns
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMatrixGetColumnNode: node [
	| matrix element temporary |
	matrix := self visitNode: node matrix.
	element := self visitNode: node element.
	^ node type isReferenceType ifTrue: [ 
		slvmBuilder getReference: matrix element: element
	] ifFalse: [
		element isConstantValue ifTrue: [ 
			slvmBuilder extractValue: matrix indices: {element value}
		] ifFalse: [
			"If the index is not a constant, then we need to spill the matrix."
			temporary := slvmBuilder allocaBuilder alloca: matrix type.
			slvmBuilder store: matrix in: temporary.
			slvmBuilder load: (slvmBuilder getReference: temporary element: element)
		].
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMatrixGetRowNode: node [
	| matrix element rowElementCount columns |
	matrix := self visitNode: node matrix.
	element := self visitNode: node element.
	rowElementCount := node type elements.
	self assert: rowElementCount >= 2.
	
	columns := (0 to: rowElementCount - 1) collect: [ :i |
		matrix type isPointerType ifTrue: [ 
			slvmBuilder getReference: matrix element: (slvmBuilder constInt: i)
		] ifFalse: [ 
			slvmBuilder extractValue: matrix indices: {i}
		]
	].

	^ self extractColumns: columns elementAsVector: element
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMatrixMultiplicationOperationNode: node [
	| leftMatrix rightMatrix |
	leftMatrix := self visitNode: node leftMatrix.
	rightMatrix := self visitNode: node rightMatrix.
	leftMatrix type isVectorType ifTrue: [
		self assert: rightMatrix type isMatrixType.
		^ slvmBuilder mulVector: leftMatrix withMatrix: rightMatrix.
	].
	rightMatrix type isVectorType ifTrue: [
		self assert: leftMatrix type isMatrixType.
		^ slvmBuilder mulMatrix: leftMatrix withVector: rightMatrix.
	].
	self assert: leftMatrix type isMatrixType.
	self assert: rightMatrix type isMatrixType.
	^ slvmBuilder mulMatrix: leftMatrix withMatrix: rightMatrix
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMethodReferenceNode: node [
	^ (codeModuleGenerator translateProgramEntity: node binding) ssaValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitNode: node [
	self isEmittingDebugInformation ifTrue: [ 
		^ self withDebugPosition: (codeModuleGenerator convertDebugPosition: node asActualSourcePosition scope: activeLexicalScope) do: [ 
			super visitNode: node
		].
	].

	^ super visitNode: node
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPatternMatchingBindingPatternNode: node [
	self assert: node value isNotNil.
	^ self visitNode: node value
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPatternMatchingLiteralValuePatternNode: node [
	^ self visitLiteralValueNode: node
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPointerAsReferenceNode: node [
	^ self visitNode: node pointer
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPointerElementReferenceNode: node [
	| pointer index |
	pointer := self visitNode: node container.
	index := self visitNode: node index.
	self assert: index type isIntegerType.
	"Convert one based indices into zero based indices."
	node isOneBasedIndex ifTrue: [ 
		index := slvmBuilder sub: index with: (SLVMConstant type: index type value: 1)
	].

	^ slvmBuilder getPointer: pointer element: { index }
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPointerReinterpretCastNode: node [
	^ self visitBitCastNode: node
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPointerToIntegerCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder pointerToIntCast: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitReferenceAsPointerNode: node [
	^ self visitNode: node reference
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitReferenceLoadNode: node [
	| reference valueType tempVar |
	reference := self visitNode: node reference.
	reference isFakeValue ifTrue: [
		reference isMbndLoadedReferenceValue ifTrue: [ ^ reference value ].
		^ reference
	].

	"Do not load the types that are passed by reference."
	valueType := node type.
	node type isTypePassedByReference ifTrue: [
		node createsImplicitTemporary ifTrue: [
			tempVar := self allocateTemporaryStorageFor: (self translateType: valueType) withStorageCreationNode: node storageCreationNode.
			self generateVariable: tempVar withValueType:node type initializationWithValue: reference initialValueKind: #copy.
			valueType hasTrivialFinalization ifFalse: [
				self addLocalVariable: tempVar withValueType: valueType cleanUpActionForNode: node
			].
			^ tempVar
		].
		^ reference
	].

	^ self sanitizeValue: ((slvmBuilder load: reference)
		volatile: node reference type isVolatileType;
		yourself) withExpectedType: (self translateType: node type)
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitReturnStatementNode: node [
	| result suppresedCleanUpTokens |
	concreteMethod returnType isMemoryReturnedType ifTrue: [
		self setStorageCreationNode: node variableForCopyEllision: ssaFunction arguments first
	].

	result := node expression ifNotNil: [ :expr | self visitNode: expr ].
	slvmBuilder isLastTerminator ifTrue: [ ^ nil ].

	suppresedCleanUpTokens := #().
	concreteMethod returnType isMemoryReturnedType ifTrue: [ 
		self assert: result isNotNil.
		self generateVariable: ssaFunction arguments first withValueType: concreteMethod returnType initializationWithValue: result initialValueKind: #move.
		suppresedCleanUpTokens := { ssaFunction arguments first }
	].

	self executeAllScopeCleanUpExceptForTokens: suppresedCleanUpTokens.
	slvmBuilder isLastTerminator ifTrue: [ ^ nil ].
	self generateAutomaticEpilogueCode.
	concreteMethod returnType isVoidType ifTrue: [
		slvmBuilder returnVoid.
		^ nil
	].

	self assert: result isNotNil.
		
	concreteMethod returnType isMemoryReturnedType ifTrue: [ 
		slvmBuilder returnVoid
	] ifFalse: [
		slvmBuilder return: result
	].
	^ nil
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSampleTextureWithExplicitDerivativesNode: node [
	| sampler texture texcoord combinedSampler dtdx dtdy |
	sampler := self visitNode: node sampler.
	texture := self visitNode: node texture.
	texcoord := self visitNode: node texcoord.
	dtdx := self visitNode: node dtdx.
	dtdy := self visitNode: node dtdy.
	self slvmCompilationTarget isGPU ifTrue: [ 
		combinedSampler := slvmBuilder combineSampler: sampler with: texture.
		^ slvmBuilder sample: combinedSampler atCoord: texcoord dtdx: dtdx dtdy: dtdy
	].

	self halt
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSampleTextureWithExplicitLodNode: node [
	| sampler texture texcoord combinedSampler lod |
	sampler := self visitNode: node sampler.
	texture := self visitNode: node texture.
	texcoord := self visitNode: node texcoord.
	lod := self visitNode: node lod.
	self slvmCompilationTarget isGPU ifTrue: [ 
		combinedSampler := slvmBuilder combineSampler: sampler with: texture.
		^ slvmBuilder sample: combinedSampler explicitLod: lod atCoord: texcoord
	].

	self halt
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSampleTextureWithImplicitLodNode: node [
	| sampler texture texcoord combinedSampler |
	sampler := self visitNode: node sampler.
	texture := self visitNode: node texture.
	texcoord := self visitNode: node texcoord.
	self slvmCompilationTarget isGPU ifTrue: [ 
		combinedSampler := slvmBuilder combineSampler: sampler with: texture.
		^ slvmBuilder sample: combinedSampler implicitLodAtCoord: texcoord
	].

	self halt
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSequenceNode: node [
	| result |
	result := nil.
	node elements do: [ :element |
		result := self visitNode: element.
		slvmBuilder isLastTerminator ifTrue: [ ^ result ].
	].

	(node type isVoidType or: [node type isUndefinedType ]) ifTrue: [ 
		result := nil.
	] ifFalse: [
		self assert: result isNotNil.
	].
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSetFieldValueNode: node [
	| aggregate newValue aggregateType field resultType fieldPointer |
	resultType := self translateType: node type.
	aggregate := self visitNode: node aggregate.
	newValue := self visitNode: node newValue.
	aggregateType := node aggregate type withoutDecorations withoutReferences.
	field := node field.

	aggregateType isUnionType ifTrue: [ 
		aggregate type isPointerType ifFalse: [ 
			aggregate := self storeValueInTemporary: aggregate
		].
	].

	aggregate type isPointerType ifTrue: [
		fieldPointer := 
			aggregateType isUnionType ifTrue: [
				slvmBuilder bitCast: aggregate target: (slvmBuilder pointerTypeFor: (self translateType: field valueType))
			] ifFalse: [
				slvmBuilder getReference: aggregate element: (slvmBuilder constInt: field slotIndex)
			].
		
		field bits ifNil: [
			slvmBuilder store: (self sanitizeStoreValue: newValue inPointer: fieldPointer)
				in: fieldPointer
		] ifNotNil: [ 
			self halt
		].
	
		^ resultType isPointerType
			ifTrue: [ aggregate ]
			ifFalse: [ slvmBuilder load: aggregate ].
	] ifFalse: [
	
		field bits ifNil: [
			aggregate := slvmBuilder insertValue: aggregate value: newValue indices: { field slotIndex }
		] ifNotNil: [ 
			self halt.
		].

		^ resultType isPointerType
			ifTrue: [ self storeValueInTemporary: aggregate ]
			ifFalse: [ aggregate ].
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSignExtensionCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder signExtend: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitStaticClassPointerCastNode: node [
	| sourceType targetType targetSlotIndex sourceValue targetSSAType |
	sourceValue := self visitNode: node expression.
	targetSSAType := self translateType: node type.
	sourceType := node expression type asUndecoratedClassType.
	targetType := node targetType asUndecoratedClassType.
	self assert: (sourceType isAbstractClassType and: [ targetType isAbstractClassType ]).
	
	"There is only single inheritance with GC classes."
	(sourceType isGCClassType and: [ targetType isGCClassType ]) ifTrue: [ 
		(targetType isSubtypeOf: sourceType) ifTrue: [ 
			self flag: 'TODO: validate the possibility of doing this down cast.'.
		].
	
		^ slvmBuilder bitCast: sourceValue target: targetSSAType
	].
	
	"Is this an upcast?"
	(sourceType isSubtypeOf: targetType) ifTrue: [ 
		targetSlotIndex := sourceType slotLayout typeStartLocations at: targetType.
		targetSlotIndex == 0 ifTrue: [ ^ slvmBuilder bitCast: sourceValue target: targetSSAType ].
		
		^ slvmBuilder
			bitCast: (slvmBuilder getReference: sourceValue element: targetSlotIndex)
			target: targetSSAType
	].
	
	"Is this a down cast?"
	(targetType isSubtypeOf: sourceType) ifTrue: [
		self halt.
	].

	self error: 'Unsupported class pointer casting type.'
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitTemporaryVariableNode: node [
	| valueType tempVar initializer |
	valueType := self translateType: node valueType.
	tempVar := self allocateTemporaryStorageFor: valueType withStorageCreationNode: node storageCreationNode.
	node hasBasicInitialization ifTrue: [ 
		self generateVariable: tempVar basicInitializationWithValueType: node valueType.
	].
	node hasInitialization ifTrue: [
		node valueType hasTrivialInitialization ifFalse: [
			initializer := node valueType initializeMethod.
			self generateCallWithReceiver: tempVar receiverType: node valueType selector: #initialize arguments: #() isSuperSend: false
				declaredMethod: initializer expectedResultType: initializer returnType
		].
	].

	node valueType hasTrivialFinalization ifFalse: [ 
		self addLocalVariable: tempVar withValueType: node valueType cleanUpActionForNode: node
	].

	^ tempVar
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitTruncateCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder truncate: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitUnwrapEnumValueCastNode: node [
	^ self visitNode: node expression
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVariableReferenceNode: node [
	| binding translatedBinding targetType |
	binding := node binding.
	functionVariables at: binding ifPresent: [ :ssaValue |
		node isSuperReference ifTrue: [
			targetType := self translateType: node type.
			self assert: targetType isPointerType.
			self assert: ssaValue type isPointerType.
			^ self slvmBuilder bitCast: ssaValue target: targetType
		].
		^ ssaValue
	].
	translatedBinding := (codeModuleGenerator translateProgramEntity: binding) ssaValue.
	targetType := self translateType: node type.
	(translatedBinding type isPointerType and: [ targetType isPointerType not]) ifTrue: [
		"Load the value of immutable variables."
		^ self slvmBuilder load: translatedBinding
	].
	^ translatedBinding
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVectorConstructionNode: node [
	| elements targetType |
	elements := self visitNodesAndCollect: node elements.
	targetType := self translateType: node type.
	^ slvmBuilder makeVector: targetType arguments: elements
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVectorGetElementsNode: node [
	| vector |
	vector := self visitNode: node vector.
	node elements size = 1 ifTrue: [
		^ node type isReferenceType
			ifTrue: [ slvmBuilder getReference: vector element: (slvmBuilder constInt: node elements first) ]
			ifFalse: [ slvmBuilder extractVector: vector element: (slvmBuilder constInt: node elements first) ].
	].

	self assert: node vector type isReferenceType not.
	^ slvmBuilder shuffleVector: vector with: vector components: (node elements)
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVectorSetElementsNode:  node [
	| vector values |
	vector := self visitNode: node vector.
	values := self visitNodesAndCollect: node values.
	node vector type isReferenceType ifTrue: [
		self assert: node vector type baseType isConstantType not.
		"Mutable case, modify the vector itself."
		node values size = 1 ifTrue: [ 
			slvmBuilder store: values first in: (slvmBuilder getReference: vector element: (slvmBuilder constInt: node elements first))
		] ifFalse: [
			slvmBuilder store: (
				self replaceVector: (slvmBuilder load: vector) elements: node elements with: values
			) in: vector
		].
	
		^ vector
	] ifFalse: [
		"Immutable case, create a new vector."
		^ self replaceVector: vector elements: node elements with: values
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitWhileLoopNode: node [
	| loopHeader loopBody loopContinue loopMerge |
	loopHeader := slvmBuilder newBasicBlock: #whileHeader.
	loopBody := slvmBuilder newBasicBlock: #whileBody.
	loopContinue := node continueAction
		ifNil: [ loopHeader ]
		ifNotNil: [ slvmBuilder newBasicBlock: #whileContinue ].
	loopMerge := slvmBuilder newBasicBlock: #whileMerge.
	
	"Enter into the loop."
	slvmBuilder
		jump: loopHeader;
		currentBlock: loopHeader.
		
	"Set the structured blocks."
	loopHeader
		continueBlock: loopContinue;
		mergeBlock: loopMerge.
	
	"Test the loop condition."
	node condition ifNil: [
		slvmBuilder jump: loopBody.
	] ifNotNil: [ :expr |
		slvmBuilder branch: (self visitNode: expr) ifTrue: loopBody ifFalse: loopMerge
	].

	"Generate the loop body."
	slvmBuilder currentBlock: loopBody.
	node action ifNotNil: [ :action |
		self withBreakBlock: loopMerge continueBlock: loopContinue do: [ 
			self visitNode: action
		]
	].

	slvmBuilder isLastTerminator ifFalse: [ 
		slvmBuilder jump: loopContinue
	].

	"Generate the continue action"
	node continueAction ifNotNil: [ :action |
		slvmBuilder currentBlock: loopContinue.

		self visitNode: action.

		slvmBuilder isLastTerminator ifFalse: [
			slvmBuilder jump: loopHeader
		]
	].

	slvmBuilder currentBlock: loopMerge.
	loopMerge predecessors ifEmpty: [
		loopHeader addUnreachableStructuredSuccessors.
		slvmBuilder unreachable.
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitWrapEnumValueCastNode: node [
	^ self visitNode: node expression
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitZeroExtensionCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder zeroExtend: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> withBreakBlock: newBreakBlock continueBlock: newContinueBlock do: aBlock [
	| oldBreakBlock oldContinueBlock |
	oldBreakBlock := currentBreakBlock.
	oldContinueBlock := currentContinueBlock.

	currentBreakBlock := newBreakBlock.
	currentContinueBlock := newContinueBlock.
	^ aBlock ensure: [ 
		currentBreakBlock := oldBreakBlock.
		currentContinueBlock := oldContinueBlock.
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> withCleanUpScope: newCleanUpScope do: aBlock [
	| result oldCleanUpScope |
	oldCleanUpScope := currentCleanUpScope.
	currentCleanUpScope := newCleanUpScope.
	[
		result := aBlock value.
		slvmBuilder isLastTerminator ifFalse: [
			self executeScopeCleanUpActions: currentCleanUpScope
		].
	] ensure: [ currentCleanUpScope := oldCleanUpScope ].
	^ result
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> withConcreteMethod: aConcreteMethod do: aBlock [
	| oldConcreteMethod |
	oldConcreteMethod := concreteMethod.
	concreteMethod := aConcreteMethod.
	^ aBlock ensure: [ 
		concreteMethod := oldConcreteMethod
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> withDebugPosition: debugPosition do: aBlock [
	self isEmittingDebugInformation ifFalse: [ ^ aBlock value ].

	"Keep track of the debug position"
	slvmBuilder pushDebugSourcePosition: debugPosition.
	slvmBuilder allocaBuilder pushDebugSourcePosition: debugPosition.
		
	^ aBlock ensure: [
		slvmBuilder popDebugSourcePosition.
		slvmBuilder allocaBuilder popDebugSourcePosition.
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> withLexicalScope: lexicalScope do: aBlock [
	| debugLexicalScope oldActiveLexicalScope |
	self isEmittingDebugInformation ifFalse: [ ^ aBlock value ].
	
	debugLexicalScope := codeModuleGenerator debugInformationTranslator translateLexicalScope: lexicalScope.
	oldActiveLexicalScope := activeLexicalScope.
	^ [ 
		activeLexicalScope := debugLexicalScope.
		aBlock value
	] ensure: [ activeLexicalScope := oldActiveLexicalScope ]
]
