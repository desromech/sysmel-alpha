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
		'storageCreationNodeVariableMapForCopyEllision',
		'entryPointLocalInitializations',
		'allCleanUpScopes',
		'unwindExceptionPointerVariable',
		'unwindExceptionSelectorVariable',
		'inCleanUpContextCount',
		'forbiddenExceptionDuringCleanupTarget',
		'nonLocalReturnContext',
		'nonLocalReturnResultVariable'
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
MbndSlovimFunctionCodeGenerator >> buildSSAClosure: ssaClosureDefinition definitionWith: blockClosureMethod [
	(self setupSSAFunction: ssaClosureDefinition definitionWithMethod: blockClosureMethod) ifTrue: [ ^ self ].
	
	"Generate the body code."
	self visitNode: concreteMethod analyzedBody.

	"Semantic analysis introduces an implicit return, so this should be always a terminator."
	self assert: slvmBuilder currentBlock isLastTerminator.
	self assert: concreteMethod analyzedBody type isReturnType.

	"Initialize the required clean up action states in the alloca block."
	self generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	"concreteMethod requiresCompiledMethodMetadata ifTrue: [
		ssaFunction
			addRequiredDynamicLiteral: concreteMethod selectorRequiredLiteral;
			addRequiredDynamicLiteral: concreteMethod classBindingLiteral;
			hasSelectorAndClassBinding: true
	]."

	self cleanUpStructuredControlFlow.
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

	"Initialize the required clean up action states in the alloca block."
	self generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	self cleanUpStructuredControlFlow.
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
	self initializeEntryPointLocals.
	self generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	concreteMethod requiresCompiledMethodMetadata ifTrue: [
		ssaFunction
			addRequiredDynamicLiteral: concreteMethod selectorRequiredLiteral;
			addRequiredDynamicLiteral: concreteMethod classBindingLiteral;
			hasSelectorAndClassBinding: true
	].

	self cleanUpStructuredControlFlow.
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

	self generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	self cleanUpStructuredControlFlow.

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
	
	self cleanUpStructuredControlFlow.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> cleanUpStructuredControlFlow [
	ssaFunction basicBlocks do: [ :bb |
		self assert: bb isEmpty not.
		bb addUnreachableStructuredSuccessors
	].

]

{ #category : #accessing }
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
			argumentValue name: argVariable name asPrettySymbolName
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
MbndSlovimFunctionCodeGenerator >> defineCapturedVariables [
	| capturedValue |
	concreteMethod isBlockClosureMethod ifFalse: [ ^ self ].
	concreteMethod capturedVariables do: [ :variable |
		capturedValue := ssaFunction createClosureCaptureOfType: (self translateType: variable type).
		capturedValue propertyAt: #mbndType put: variable type.
		functionVariables at: variable put: capturedValue
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
	action finalizationActionBlocks do: [:each | each value].
	slvmBuilder isLastTerminator ifFalse: [ slvmBuilder jump: mergeBlock ].

	slvmBuilder currentBlock: mergeBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeScopeCleanUpActions: cleanUpScope [
	^ self executeScopeCleanUpActions: cleanUpScope exceptForTokens: #()
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeScopeCleanUpActions: cleanUpScope exceptForTokens: suppressedCleanUpTokens [
	self inCleanUpContextDo: [ 
		cleanUpScope implicitFinalizationStateDictionary valuesDo: [ :action |
			(suppressedCleanUpTokens includes: action token) ifFalse: [ 
				self executeImplicitFinalizationAction: action
			].
		].
		cleanUpScope explicitFinalizationAction ifNotNil: [ :ac |
			ac value
		].

		slvmBuilder currentUnwindBlock == forbiddenExceptionDuringCleanupTarget ifFalse: [
			cleanUpScope parentCatchAction ifNotNil: [ :catchAction |
				self generateExceptionCatchEndFor: catchAction
			].
		].
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

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> forbiddenExceptionDuringCleanupTarget [
	^ forbiddenExceptionDuringCleanupTarget ifNil: [ ^ forbiddenExceptionDuringCleanupTarget := slvmBuilder newBasicBlock: #forbiddenExceptionTarget ]
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
MbndSlovimFunctionCodeGenerator >> generateAutomaticInitializationFromCopyCode [
	self flag: 'TODO: Implement this method properly.'.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticInitializationMovingFromCode [
	self flag: 'TODO: Implement this method properly.'.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticPrologueCode [
	concreteMethod ifNil: [ ^ self ].
	(concreteMethod isMessageMethod and: [ concreteMethod name = #initialize and: [concreteMethod hasExplicitSuperSend not ]]) ifTrue: [
		self generateAutomaticInitializationCode
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCall: calledFunction arguments: arguments argumentTypes: argumentTypes expectedResultType: expectedResultType hiddenReceiverArgument: hiddenReceiverArgument storageCreationNode: storageCreationNode cleanUpActionNode: cleanUpActionNode [
	| expectedResultSSAType memoryReturnTemporary allArguments result |
	expectedResultSSAType := self translateType: expectedResultType.
	memoryReturnTemporary := nil.

	allArguments := Array streamContents: [:out |
		expectedResultType isMemoryReturnedType ifTrue: [ 
			memoryReturnTemporary := self allocateTemporaryStorageFor: expectedResultSSAType withStorageCreationNode: storageCreationNode.
			out nextPut: memoryReturnTemporary
		].
	
		hiddenReceiverArgument ifNotNil: [ 
			out nextPut: hiddenReceiverArgument.
		].

		arguments do: [:arg |
			out nextPut: arg
		].
	].

	result := slvmBuilder call: calledFunction arguments: allArguments.
	(calledFunction isFunction and: [ calledFunction isNoReturn ]) ifTrue: [
		slvmBuilder unreachable.
		^ result
	].
	
	memoryReturnTemporary ifNotNil: [
		expectedResultType hasTrivialFinalization ifFalse: [
			cleanUpActionNode ifNotNil: [ 
				self addLocalVariable: memoryReturnTemporary withValueType: expectedResultType cleanUpActionForNode: cleanUpActionNode
			] ifNil: [
				self assert: concreteMethod isConcreteMethod not.
			].
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

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCall: calledFunction arguments: arguments calledFunctionType: functionType [
	^ self generateCall: calledFunction arguments: arguments
		argumentTypes: functionType argumentTypes expectedResultType: (functionType returnType asConcreteTypeForAnalysisOfFunctionType: functionType)
		hiddenReceiverArgument: nil storageCreationNode: nil cleanUpActionNode: nil
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
		result highLevelMessageSendFunctionType: declaredMethod type asCanonicalMessageSendFunctionType.
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
			[ currentCase isNotNil and: [ currentCase pattern isPatternMatchingLiteralValueSetPatternNode ] ] whileTrue: [ 
				out nextPut: caseStream next.
				currentCase := caseStream peek.
			]
		].
	
		literalCases ifNotEmpty: [
			| caseConstants caseConstantBlocks caseBlocks defaultBlock mergeBlock switchBlock |
			caseBlocks := literalCases collect: [ :case | slvmBuilder newBasicBlock: #casesOfCase ].
			caseConstants := OrderedCollection new.
			caseConstantBlocks := OrderedCollection new.
			literalCases doWithIndex: [ :case :index |
				| block |
				block := caseBlocks at: index.
				(self visitNode: case pattern) do: [ :literalConstant |
					caseConstants add: literalConstant.
					caseConstantBlocks add: block
				]
			].

			defaultBlock := slvmBuilder newBasicBlock: #casesOfDefault.
			mergeBlock := slvmBuilder newBasicBlock: #casesOfMerge.

			switchBlock := slvmBuilder currentBlock.
			slvmBuilder currentBlock mergeBlock: mergeBlock.
			slvmBuilder switch: matchedValue caseConstants: caseConstants asArray caseBlocks: caseConstantBlocks asArray defaultBlock: defaultBlock.
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

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateCatchedExceptionAction: scopeCatchedExceptionAction [
	| catchExceptionScope |
	"We need a special scope for connecting with the finally action."
	catchExceptionScope := MbndSlovimExceptionScope new
		parent: currentCleanUpScope;
		parentCatchAction: scopeCatchedExceptionAction;
		compilationTarget: self compilationTarget;
		scopeEntryBlock: scopeCatchedExceptionAction catchActionBlock;
		normalCleanUpBlock: (slvmBuilder newBasicBlock: #catchNormalCleanUp);
		unwindBlock: (slvmBuilder newBasicBlock: #catchUnwind);
		isInCleanUpAction: false;
		yourself.
	catchExceptionScope unwindBlock unwindBlock: nil.
	catchExceptionScope normalCleanUpBlock unwindBlock: currentCleanUpScope parent unwindBlock.
	allCleanUpScopes add: catchExceptionScope.

	slvmBuilder withBasicBlock: scopeCatchedExceptionAction catchActionBlock do: [
		| caughtExceptionReference |
		caughtExceptionReference := self generateExceptionCatchBeginFor: scopeCatchedExceptionAction.
		scopeCatchedExceptionAction node caughtExceptionReferenceNode ifNotNil: [ :refNode |
			functionVariables at: refNode put: caughtExceptionReference
		].
	
		self withExceptionScope: catchExceptionScope do: [ 
			self visitNode: scopeCatchedExceptionAction node catchAction.
		].
	
		slvmBuilder isLastTerminator ifFalse: [ 
			slvmBuilder jump: catchExceptionScope parent normalCleanUpBlock.
		].
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCleanUpActionActivatedHereForNode: node token: token with: aBlock [
	| cleanUpActionState activatedFlag |
	self assert: currentCleanUpScope isNotNil.
	self assert: (currentCleanUpScope allowedNodesWithImplicitFinalization includes: node).
	cleanUpActionState := currentCleanUpScope implicitFinalizationStateDictionary at: token ifAbsentPut: [
		implicitCleanUpActionStates add: (MbndSlovimExceptionScopeImplicitFinalizationState new
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
MbndSlovimFunctionCodeGenerator >> generateExceptionCatchBeginFor: exceptionCatchAction [
	| exceptionPointer |
	exceptionPointer := slvmBuilder load: self unwindExceptionPointerVariable.
	^ slvmBuilder call: codeModuleGenerator exceptionCatchBeginFunction arguments: {exceptionPointer}
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateExceptionCatchEndFor: exceptionCatchAction [
	slvmBuilder call: codeModuleGenerator exceptionCatchEndFunction arguments: #().
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
	selectorValue :=
		declaredMethod
			ifNil: [ self visitNode: node selector ]
			ifNotNil: [ declaredMethod sendTypedSelector ].
	
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

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateForbiddenExceptionDuringCleanupTarget [
	| builder landingPath exceptionPointer |
	forbiddenExceptionDuringCleanupTarget ifNil: [ ^ self ].
	builder := SLVMBuilder on: ssaFunction.
	builder currentBlock: self forbiddenExceptionDuringCleanupTarget.
	self isEmittingDebugInformation ifTrue: [ 
		builder pushDebugSourcePosition: (codeModuleGenerator convertDebugPosition: concreteMethod definitionPosition asActualSourcePosition scope: nil)
	].

	landingPath := builder landingPath: codeModuleGenerator landingPathResultType.
	landingPath catchedExceptions: {SLVMConstant nullPointer: self slvmCompilationTarget voidPointerType}.
	
	exceptionPointer := builder extractValue: landingPath indices: #(0).
	builder call: (codeModuleGenerator forbiddenExceptionHandlingFunction) arguments: { exceptionPointer }.
	builder unreachable.

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
MbndSlovimFunctionCodeGenerator >> generateUnwindingCatchSelectionFor: exceptionScope [
	self assert: exceptionScope catchSelectionBlock isNotNil.
	exceptionScope catchSelectionBlock == exceptionScope unwindCleanUpBlock ifTrue: [ ^ self ].
	
	slvmBuilder currentBlock: exceptionScope catchSelectionBlock.
	self withUnwindBlock: self forbiddenExceptionDuringCleanupTarget do: [ 
		exceptionScope catchedExceptions do: [ :each |
			self generateUnwindingCatchTestingForException: each
		].
		
		slvmBuilder jump: exceptionScope unwindCleanUpBlock
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateUnwindingCatchTestingForException: catchedException [
	| typeInfoConstant typeInfoSelector currentSelector isMatchingTypeInfo exceptionSelectContinueBlock |
	typeInfoConstant := (codeModuleGenerator translateProgramEntity: catchedException node exceptionType) ssaValue.
	currentSelector := slvmBuilder load: self unwindExceptionSelectorVariable.
	typeInfoSelector := slvmBuilder getExceptionSelectorForTypeInfo: typeInfoConstant.
	isMatchingTypeInfo := slvmBuilder ieq: currentSelector with: typeInfoSelector.
	exceptionSelectContinueBlock := slvmBuilder newBasicBlock: #catchSelectContinue.
	catchedException node exceptionTypeIsLiteral ifTrue: [
		self assert: slvmBuilder currentBlock mergeBlock isNil.
		slvmBuilder currentBlock mergeBlock: exceptionSelectContinueBlock.
		slvmBuilder branch: isMatchingTypeInfo ifTrue: catchedException catchActionBlock ifFalse: exceptionSelectContinueBlock.
	] ifFalse: [
		"This is a case that requires further testing."
		self halt.
	].

	slvmBuilder currentBlock: exceptionSelectContinueBlock
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateUnwindingCleanUpFor: exceptionScope [
	| resumeValue |
	self assert: slvmBuilder currentUnwindBlock isNil.
	self assert: exceptionScope unwindCleanUpBlock isEmpty.
	slvmBuilder currentBlock: exceptionScope unwindCleanUpBlock.
	self withUnwindBlock: self forbiddenExceptionDuringCleanupTarget do: [ 
		self executeScopeCleanUpActions: exceptionScope.
	].
	
	slvmBuilder isLastTerminator ifTrue: [ ^ self ].

	"If this block is empty, it cannot have an unwind destination anymore."
	slvmBuilder currentBlock isEmpty ifTrue: [ slvmBuilder currentBlock unwindBlock: nil ].
	
	exceptionScope parent ifNotNil: [ :parent |
		"If this is inside a catch, we need to skip the catch selection clauses from the parent."
		exceptionScope parentCatchAction ifNotNil: [
			self assert: parent unwindCleanUpBlock isNotNil.
			^ slvmBuilder jump: parent unwindCleanUpBlock
		].
	
		parent catchSelectionBlock ifNotNil: [ :parentCleanUp |
			^ slvmBuilder jump: parent catchSelectionBlock
		].
	].

	self compilationTarget usesExceptionsForNonLocalReturns ifTrue: [ 
		exceptionScope nonLocalReturnContext ifNotNil: [
			self generateUnwindingNonLocalReturnCatch.
		].
	].

	resumeValue := SLVMConstant undefined: codeModuleGenerator landingPathResultType.
	resumeValue := slvmBuilder insertValue: resumeValue value: (slvmBuilder load: self unwindExceptionPointerVariable) indices: #(0).
	resumeValue := slvmBuilder insertValue: resumeValue value: (slvmBuilder load: self unwindExceptionSelectorVariable) indices: #(1).
	^ slvmBuilder resumeException: resumeValue
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateUnwindingCode [
	| unusedUnwindBlocks unwindBlockReplacementDictionary |
	self assert: slvmBuilder currentUnwindBlock isNil.
	self hasExceptions ifFalse: [
		self assert: (ssaFunction basicBlocks detect: [ :each | each unwindBlock ~~ nil ] ifFound: [ false ] ifNone: [ true]).
		self removeUnusedCleanUpActionStates.
		^ self
	].

	"Create a list with the unused unwind blocks and a replacement dictionary for them."	
	unusedUnwindBlocks := OrderedCollection new.
	unwindBlockReplacementDictionary := Dictionary new.

	allCleanUpScopes do: [ :cleanUpScope |
		| parent |
		parent := cleanUpScope parent.
		(cleanUpScope isNopExceptionScope and: [ cleanUpScope isInCleanUpAction not ]) ifTrue: [
			| unusedUnwindBlock newUnwindBlock |
			unusedUnwindBlock := cleanUpScope unwindBlock.
			newUnwindBlock := nil.
			"These scopes are in pre-order, so parent are always before their
			children (i.e. there are topologically sorted)."
			parent ifNotNil: [
				newUnwindBlock := parent unwindBlock.
				cleanUpScope
					unwindBlock: newUnwindBlock;
					catchSelectionBlock: parent catchSelectionBlock;
					unwindCleanUpBlock: parent catchSelectionBlock.
			] ifNil: [ 
				cleanUpScope
					unwindBlock: nil;
					catchSelectionBlock: nil;
					unwindCleanUpBlock: nil.
			].
		
			unusedUnwindBlocks add: unusedUnwindBlock.
			unwindBlockReplacementDictionary at: unusedUnwindBlock put: newUnwindBlock.
		] ifFalse: [
			cleanUpScope isInCleanUpAction ifFalse: [
				cleanUpScope unwindCleanUpBlock: (slvmBuilder newBasicBlock: #unwindCleanUp).
				cleanUpScope unwindCleanUpBlock unwindBlock: self forbiddenExceptionDuringCleanupTarget.
				cleanUpScope catchedExceptions ifEmpty: [
					cleanUpScope catchSelectionBlock: cleanUpScope unwindCleanUpBlock
				] ifNotEmpty: [
					cleanUpScope catchSelectionBlock: (slvmBuilder newBasicBlock: #unwindCatchSelection).
					cleanUpScope catchSelectionBlock unwindBlock: self forbiddenExceptionDuringCleanupTarget.
				].
			].
		].
	].

	"Replace the removed unwind blocks."
	ssaFunction basicBlocks do: [ :each |
		unwindBlockReplacementDictionary at: each unwindBlock ifPresent: [ :replacement |
			each unwindBlock: replacement
		]
	].

	"Remove the unused unwind blocks."
	unusedUnwindBlocks do: [ :each | each removeFromFunction ].
	
	"Generate the per scope landing pad, catch clauses, and cleanup."
	allCleanUpScopes do: [ :each |
		each isNopExceptionScope ifFalse: [
			self generateUnwindingCodeForExceptionScope: each 
		]
	].

	forbiddenExceptionDuringCleanupTarget ifNotNil: [
		ssaFunction basicBlocks detect: [ :each |each unwindBlock == forbiddenExceptionDuringCleanupTarget ] ifFound: [ 
			self generateForbiddenExceptionDuringCleanupTarget
		] ifNone: [
			forbiddenExceptionDuringCleanupTarget removeFromFunction
		].
	].

	self removeUnusedCleanUpActionStates.

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateUnwindingCodeForExceptionScope: exceptionScope [
	self generateUnwindingLandingPadFor: exceptionScope.
	self generateUnwindingCatchSelectionFor: exceptionScope.
	self generateUnwindingCleanUpFor: exceptionScope.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateUnwindingLandingPadFor: exceptionScope [
	| landingPath |
	self assert: slvmBuilder currentUnwindBlock isNil.
	slvmBuilder currentBlock: exceptionScope unwindBlock.
	ssaFunction personalityFunction: codeModuleGenerator personalityFunction.

	landingPath := slvmBuilder landingPath: codeModuleGenerator landingPathResultType.
	landingPath
		catchedExceptions: (exceptionScope flattenedCatchedExceptions collect: [:each | (self translateProgramEntity: each) ssaValue ]);
		cleanup: exceptionScope isCleanUpScopeOrParentCleanUp.

	slvmBuilder store: (slvmBuilder extractValue: landingPath indices: {0}) in: self unwindExceptionPointerVariable.
	slvmBuilder store: (slvmBuilder extractValue: landingPath indices: {1}) in: self unwindExceptionSelectorVariable.
	
	slvmBuilder jump: exceptionScope catchSelectionBlock
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateUnwindingNonLocalReturnCatch [
	| typeInfoConstant currentSelector typeInfoSelector isNonLocalReturnException nonLocalReturnBlock unwindResumeBlock |
	typeInfoConstant := (codeModuleGenerator translateProgramEntity: self compilationTarget internalNonLocalReturnExceptionClass) ssaValue.
	currentSelector := slvmBuilder load: self unwindExceptionSelectorVariable.
	typeInfoSelector := slvmBuilder getExceptionSelectorForTypeInfo: typeInfoConstant.
	isNonLocalReturnException := slvmBuilder ieq: currentSelector with: typeInfoSelector.
	nonLocalReturnBlock := slvmBuilder newBasicBlock: #nonLocalReturn.
	unwindResumeBlock := slvmBuilder newBasicBlock: #unwindResume.
	slvmBuilder currentBlock mergeBlock: unwindResumeBlock.
	slvmBuilder branch: isNonLocalReturnException ifTrue: nonLocalReturnBlock ifFalse: unwindResumeBlock.
	
	slvmBuilder currentBlock: nonLocalReturnBlock.
	slvmBuilder call: codeModuleGenerator nonLocalReturnCatchFunction arguments: { slvmBuilder load: self unwindExceptionPointerVariable }.
	nonLocalReturnResultVariable ifNil: [
		self assert: concreteMethod returnType isVoidType.
		slvmBuilder returnVoid
	] ifNotNil: [
		self assert: concreteMethod returnType isVoidType not.
		slvmBuilder return: (slvmBuilder load: nonLocalReturnResultVariable)
	].

	slvmBuilder currentBlock: unwindResumeBlock
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

		valueType hasTrivialInitializationCopyingFrom ifTrue: [
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
			slvmBuilder call: (self translateProgramEntity: valueType initializeCopyingFromMethod) ssaValue arguments: {ssaValue . initialValue}
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
	
	leftOperand := slvmBuilder shuffleVector: leftVector with: rightVector components: #(0 2).
	rightOperand := slvmBuilder shuffleVector: leftVector with: rightVector components: #(3 1).
	multiplication := slvmBuilder vectorMul: leftOperand with: rightOperand.
	leftProduct := slvmBuilder extractVector: multiplication element: (slvmBuilder constInt: 0).
	rightProduct := slvmBuilder extractVector: multiplication element: (slvmBuilder constInt: 1).
	^ vectorType baseType isFloatType ifTrue: [ 
		slvmBuilder fsub: leftProduct with: rightProduct
	] ifFalse: [ 
		slvmBuilder sub: leftProduct with: rightProduct
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateVectorLength2Intrinsic: node [
	| vector |
	vector := self visitNode: node receiver.
	^ slvmBuilder vectorDot: vector with: vector
]

{ #category : #testing }
MbndSlovimFunctionCodeGenerator >> hasExceptions [
	^ codeModuleGenerator hasExceptions
]

{ #category : #enumerating }
MbndSlovimFunctionCodeGenerator >> inCleanUpContextDo: aBlock [
	inCleanUpContextCount := inCleanUpContextCount + 1.
	aBlock ensure: [ inCleanUpContextCount := inCleanUpContextCount - 1 ]
]

{ #category : #initialization }
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

{ #category : #initialization }
MbndSlovimFunctionCodeGenerator >> initializeArgumentVariables [
	concreteMethod arguments do: [ :argument |
		self initializeArgumentVariable: argument
	]
]

{ #category : #initialization }
MbndSlovimFunctionCodeGenerator >> initializeEntryPointLocals [
	entryPointLocalInitializations do: [ :each | each value]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> initializeImplicitCleanUpFlagsInScope: cleanUpScope [
	| falseConstant initializationInstructions |
	falseConstant := SLVMConstant bool: false.
	initializationInstructions := OrderedCollection new.
	cleanUpScope implicitFinalizationStateDictionary valuesDo: [ :implicitState |
		implicitState finalizationActivated ifNotNil: [ :var |
			initializationInstructions add: (SLVMStoreInstruction value: falseConstant variable: var)
		].
	].

	cleanUpScope scopeEntryBlock addInstructions: initializationInstructions after: nil.

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> initializeNonLocalReturnContext [
	| nonLocalReturnTargetVar |
	concreteMethod isNonLocalReturnTargetEntity ifFalse: [ ^ self ].
	nonLocalReturnTargetVar := concreteMethod getNonLocalReturnTarget.
	nonLocalReturnTargetVar ifNil: [ ^ self ].
	nonLocalReturnTargetVar hasCaptureInNonInlinedBlock ifFalse: [
		"This may still be captured in a block with immediate activation."
		functionVariables at: nonLocalReturnTargetVar put: #dummyNonLocalReturnTargetVar.
		concreteMethod getNonLocalResultVariable ifNotNil: [ :var |
			functionVariables at: var put: #dummyNonLocalResultVariable.
		].
		^ self
	].

	nonLocalReturnContext := slvmBuilder getThisContext type: (self translateType: concreteMethod getNonLocalReturnTarget type).
	nonLocalReturnResultVariable := nil.
	functionVariables at: nonLocalReturnTargetVar put: nonLocalReturnContext.
	
	concreteMethod getNonLocalResultVariable ifNotNil: [ :var |
		ssaFunction functionType returnType isVoidType ifTrue: [
			concreteMethod returnType isMemoryReturnedType ifTrue: [
				nonLocalReturnResultVariable := ssaFunction arguments first.
			].
		] ifFalse: [ 
			nonLocalReturnResultVariable := slvmBuilder allocaBuilder alloca: ssaFunction functionType returnType
		].
	
		functionVariables at: var put: nonLocalReturnResultVariable.
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> makeDynamicArrayInstanceWithFixedSize: fixedSize [
	| arrayClass method requiredArgumentType receiver argument constructor |
	arrayClass := self compilationTarget managedObjectModel arrayClass.
	fixedSize = 0 ifTrue: [
		| emptyArray |
		emptyArray := slvmBuilder addDynamicLiteral: #().
		^ slvmBuilder bitCast: emptyArray target: (self translateType: arrayClass)
	].

	method := arrayClass type lookupOverloadedSelector: #basicNew:.
	self assert: method isNotNil.
	self assert: method isConcreteMethod.
	self assert: method boundType argumentTypes size = 1.
	
	requiredArgumentType := method boundType argumentTypes first.
	self assert: requiredArgumentType isPrimitiveIntegerType.
	
	receiver := slvmBuilder bitCast: (slvmBuilder addDynamicLiteral: arrayClass)
		target: (self translateType: method receiverType).
	constructor := (self translateProgramEntity: method) ssaValue.
	argument := SLVMConstant type: (self translateType: requiredArgumentType) value: fixedSize.
	^ slvmBuilder bitCast: (slvmBuilder call: constructor arguments: { receiver . argument })
		target: (self translateType: arrayClass)
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

{ #category : #removing }
MbndSlovimFunctionCodeGenerator >> removeUnusedCleanUpActionStates [
	implicitCleanUpActionStates do: [ :cleanUpState |
		cleanUpState finalizationActivated ifNotNil: [ :activatedFlag |
			cleanUpState isActuallyExecuted ifFalse: [
				"Remove any reference to an unused clean-up action state."
				activatedFlag instructionReferences asArray do: [ :ref |
					self assert: ref isStore.
					ref removeFromBlock.
				].
				activatedFlag removeFromBlock
			].
		].
	]
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
	slvmBuilder := MbndSLVMBuilder on: ssaFunction.
	ssaFunctionEntryBlock := slvmBuilder newBasicBlockHere: #entry.
	entryPointLocalInitializations := OrderedCollection new.
	implicitCleanUpActionStates := OrderedCollection new.
	allCleanUpScopes := OrderedCollection new.
	storageCreationNodeVariableMapForCopyEllision := IdentityDictionary new.
	inCleanUpContextCount := 0.

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

	"Define the captured variables."
	self defineCapturedVariables.
	
	"Define the argument values."
	self defineArgumentValues.

	self setupBuilders.
	
	"Initialize the argument variables."
	self initializeArgumentVariables.
	self initializeNonLocalReturnContext.
	
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

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> unwindExceptionPointerVariable [
	^ unwindExceptionPointerVariable ifNil: [ unwindExceptionPointerVariable := slvmBuilder allocaBuilder alloca: self slvmCompilationTarget voidPointerType name: #exceptionPointer ]
]

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> unwindExceptionSelectorVariable [
	^ unwindExceptionSelectorVariable ifNil: [ unwindExceptionSelectorVariable := slvmBuilder allocaBuilder alloca: self slvmCompilationTarget int name: #exceptionSelector ]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> unwrapDynamicObject: dynamicObjectValue withType: dynamicObjectType intoValueOfType: targetType [
	self assert: dynamicObjectType isGarbageCollectedType.
	
	targetType isGarbageCollectedType ifTrue: [ 
		self flag: 'TODO: Perform a type check here.'.
		^ slvmBuilder bitCast: dynamicObjectValue target: (self translateType: targetType)
	].

	targetType isPrimitiveBooleanType ifTrue: [ 
		^ slvmBuilder dynamicObjectToBoolCast: dynamicObjectValue target: (self translateType: targetType)
	].

	targetType isPrimitiveCharacterCodeType ifTrue: [ 
		^ slvmBuilder dynamicObjectToCharCast: dynamicObjectValue target: (self translateType: targetType)
	].

	targetType isPrimitiveIntegerType ifTrue: [ 
		^ slvmBuilder dynamicObjectToIntCast: dynamicObjectValue target: (self translateType: targetType)
	].

	targetType isPrimitiveFloatType ifTrue: [ 
		^ slvmBuilder dynamicObjectToFloatCast: dynamicObjectValue target: (self translateType: targetType)
	].

	targetType isPointerLikeType ifTrue: [
		self flag: 'TODO: Implement this case properly.'.
		^ SLVMConstant nullPointer: (self translateType: targetType) 
	].

	targetType isVoidType ifTrue: [ ^ nil ].

	self error: 'TODO: Implement this case.'
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
	| closureDefinition captures closureInstance |
	self assert: node isBlockClosureWithImmediateActivation not.
	closureDefinition := (self translateProgramEntity: node blockClosureProgramEntity) ssaValue.
	captures := node blockClosureProgramEntity capturedVariables collect: [ :var | functionVariables at: var upperContextVariable ].
	closureInstance := slvmBuilder instantiateClosure: closureDefinition captures: captures.
	^ slvmBuilder bitCast: closureInstance target: (self translateType: node type)
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitBooleanNode: node [
	| result expectedType |
	result := self visitNode: node.
	expectedType := self slvmCompilationTarget bool.
	node type isGarbageCollectedType ifTrue: [
		result := slvmBuilder dynamicObjectToBoolCast: result target: expectedType
	].
	^ self sanitizeValue: result withExpectedType: expectedType
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
MbndSlovimFunctionCodeGenerator >> visitCaughtExceptionReferenceNode: node [
	^ functionVariables at: node
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitCharacterToDynamicObjectCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder charToDynamicObjectCast: source target: targetType
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
MbndSlovimFunctionCodeGenerator >> visitConvertToCompilerObjectCastNode: node [
	| underlyingObjectType castedValued convertedValue expectedType |
	underlyingObjectType := node type underlyingObjectType.
	underlyingObjectType type isGCClassType ifFalse: [
		^ (self translateType: underlyingObjectType) defaultConstant
	].

	castedValued := self visitNode: node expression.
	convertedValue := self wrapValue: castedValued withType: node expression type intoDynamicObjectWithType: underlyingObjectType.
	expectedType := self translateType: node type.
	self assert: convertedValue type == expectedType.
	^ convertedValue 
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
MbndSlovimFunctionCodeGenerator >> visitExceptionScopeNode: node [
	| cleanUpScope resultTemporary resultValue resultImplicitFinalization |
	cleanUpScope := MbndSlovimExceptionScope new
		parent: currentCleanUpScope;
		compilationTarget: self compilationTarget.
	(currentCleanUpScope isNil and: nonLocalReturnContext isNotNil) ifTrue: [ 
		cleanUpScope nonLocalReturnContext: nonLocalReturnContext
	].

	allCleanUpScopes add: cleanUpScope.
	cleanUpScope allowedNodesWithImplicitFinalization: node nodesWithImplicitFinalization.
	self hasExceptions ifTrue: [
		cleanUpScope catchedExceptions: (node catchExpressions collect: [:catchNode |
			MbndSlovimExceptionScopeCatchAction new
				scope: cleanUpScope;
				catchActionBlock: (slvmBuilder newBasicBlock: #catchAction);
				node: catchNode;
				yourself
		]).
	].
	
	(slvmBuilder currentBlock isEmpty and: [ slvmBuilder currentBlock unwindBlock isNil ]) ifTrue: [ 
		cleanUpScope scopeEntryBlock: slvmBuilder currentBlock.
	] ifFalse: [
		cleanUpScope scopeEntryBlock: (slvmBuilder newBasicBlock: #tryScope).
		slvmBuilder jump: cleanUpScope scopeEntryBlock.
		slvmBuilder currentBlock: cleanUpScope scopeEntryBlock.
	].

	cleanUpScope isInCleanUpAction: inCleanUpContextCount > 0.
	self hasExceptions ifTrue: [
		cleanUpScope normalCleanUpBlock: (slvmBuilder newBasicBlock: #normalCleanUpBlock).
		cleanUpScope isInCleanUpAction ifTrue: [ 
			cleanUpScope unwindBlock: self forbiddenExceptionDuringCleanupTarget
		] ifFalse: [ 
			cleanUpScope unwindBlock: (slvmBuilder newBasicBlock: #tryUnwind).
			cleanUpScope scopeEntryBlock unwindBlock: cleanUpScope unwindBlock.
			cleanUpScope unwindBlock unwindBlock: nil.
		].
	].

	node explicitCleanUpActions ifNotEmpty: [ 
		cleanUpScope explicitFinalizationAction: [
			node explicitCleanUpActions do: [ :cleanUpAction | self visitNode: cleanUpAction ]
		].
	].

	resultTemporary := nil.
	resultImplicitFinalization := nil.
	self withExceptionScope: cleanUpScope do: [ 
		resultValue := self visitNode: node expression.
		cleanUpScope catchedExceptions do: [ :each |
			self generateCatchedExceptionAction: each
		].
			
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

	"Set the initialized flags to false at the beginning of the clean-up scope."
	self initializeImplicitCleanUpFlagsInScope: cleanUpScope.

	^ resultValue
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
	sendInstruction highLevelMessageSendFunctionType: (self compilationTarget
		functionTypeWithArguments: { node receiver type } , (node arguments collect: [:arg | arg type])
		returnType: node type
	) asCanonicalMessageSendFunctionType.
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
	| functionValue argumentValues intrinsicName expectedResultType hiddenReceiverArgument hiddenReceiverArgumentIndex |
	functionValue := nil.
	node function isMethodReferenceNode ifTrue: [ 
		node function binding pragmaAt: #intrinsic: ifPresent: [ :pragma |
			intrinsicName := pragma arguments first value.
			(EvaluationOnlyIntrinsics includes: intrinsicName) ifFalse: [
				functionValue := codeModuleGenerator intrinsicConstantBuiltInFunction: (IntrinsicTargetMap at: intrinsicName ifAbsent: [ intrinsicName ]) withType: node function binding type.
			].
		].
	].

	expectedResultType := node functionReturnType.
	hiddenReceiverArgumentIndex := 1.
	expectedResultType isMemoryReturnedType ifTrue: [ hiddenReceiverArgumentIndex := 2].
	
	hiddenReceiverArgument := nil.
	functionValue ifNil: [
		functionValue := self visitNode: node function.
		node function type isBlockClosureType ifTrue: [ 
			| blockClosure |
			blockClosure := functionValue.
			functionValue := slvmBuilder load: (slvmBuilder getReference: functionValue element: (slvmBuilder constInt: 1)).
			self assert: functionValue type isPointerType.
			self assert: functionValue type baseType isFunctionType.
			
			hiddenReceiverArgument := slvmBuilder bitCast: blockClosure target: (functionValue type baseType arguments at: hiddenReceiverArgumentIndex).
		].
	].
	
	^ self generateCall: functionValue
		arguments: (self visitNodesAndCollect: node arguments)
		argumentTypes: (node arguments collect: [:each | each type])
		expectedResultType: expectedResultType
		hiddenReceiverArgument: hiddenReceiverArgument
		storageCreationNode: node storageCreationNode cleanUpActionNode: node
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
	| channel messageType result |
	channel := self visitNode: node channel.
	messageType := self translateType: node channel type messageType.
	
	node channel type specialSemantics ifNotNil: [
		^ slvmBuilder load: channel
	].
	
	codeModuleGenerator compilationTarget inputChannelImplementationType ifNotNil: [ :implType |
		self halt
	].

	self assert: channel type isDynamicObjectPointerType.
	result := slvmBuilder send: (slvmBuilder addDynamicLiteral: #receive) returnType: messageType receiver: channel arguments: #().
	result highLevelMessageSendFunctionType: (node channel type => node channel type messageType).
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIOChannelSendAction: node [
	| channel message send |
	channel := self visitNode: node channel.
	message := self visitNode: node message.
	
	node channel type specialSemantics ifNotNil: [
		slvmBuilder store: message in: channel.
		^ channel
	].

	codeModuleGenerator compilationTarget outputChannelImplementationType ifNotNil: [ :implType |
		self halt
	].

	self assert: channel type isDynamicObjectPointerType.
	send := slvmBuilder send: (slvmBuilder addDynamicLiteral: #send:) returnType: channel type receiver: channel arguments: { message }.
	send highLevelMessageSendFunctionType: (node channel type , node message type => self compilationTarget voidType).
	^ channel
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIfConditionNode: node [
	| condition mergeBlock thenBlock elseBlock trueResult falseResult hasTrueResult hasFalseResult resultType branchBlock |
	condition := self visitBooleanNode: node condition.
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
	
	"Set the block closure captured variables."
	blockProgramEntity capturedVariables do: [ :var |
		functionVariables at: var put: (functionVariables at: var upperContextVariable)
	].
	
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
		self visitExceptionScopeNode: node
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitLiteralValueNode: node [
	node type isGarbageCollectedType ifTrue: [
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
MbndSlovimFunctionCodeGenerator >> visitPatternMatchingIntervalPatternNode: node [
	| type startConstant endConstant |
	self assert: node isPatternMatchingLiteralValueSetPatternNode.
	type := node type.
	startConstant := self visitNode: node start.
	endConstant := self visitNode: node stop.
	self assert: startConstant isConstantValue.
	self assert: endConstant isConstantValue.
	^ (startConstant value to: endConstant value) collect: [ :value |
		SLVMConstant type: startConstant type value: value
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPatternMatchingLiteralValuePatternNode: node [
	^ {self visitLiteralValueNode: node}
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPatternMatchingSameValuePatternNode: node [
	^ self visitNode: node expectedValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitPatternMatchingSetPatternNode: node [
	self assert: node isPatternMatchingLiteralValueSetPatternNode.
	^ node elements collect: [ :each | self visitNode: each ]
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
	| result suppresedCleanUpTokens nonLocalReturnTargetRef nonLocalReturnResultRef memoryReturnedValueTarget |
	(node implicitReturn and: [ node isInImmediatelyActivatedClosure ]) ifTrue: [
		^ node expression ifNotNil: [ :expr | ^ self visitNode: expr ]
	].

	nonLocalReturnTargetRef := node nonLocalReturnTarget ifNotNil: [ :var | functionVariables at: var ] .
	nonLocalReturnResultRef := node nonLocalResultVariable ifNotNil: [ :var | functionVariables at: var ].
	nonLocalReturnTargetRef isSymbol ifTrue: [
		self assert: (nonLocalReturnTargetRef beginsWith: #dummy).
		nonLocalReturnTargetRef := nil.
		nonLocalReturnResultRef := nil.
	].

	node expectedReturnType isMemoryReturnedType ifTrue: [
		memoryReturnedValueTarget := nonLocalReturnResultRef ifNil: [ssaFunction arguments first].
		self setStorageCreationNode: node variableForCopyEllision: memoryReturnedValueTarget
	].

	result := node expression ifNotNil: [ :expr | self visitNode: expr ].
	slvmBuilder isLastTerminator ifTrue: [ ^ nil ].
	self assert: node expectedReturnType isReturnType not.

	suppresedCleanUpTokens := #().
	node expectedReturnType isMemoryReturnedType ifTrue: [ 
		self assert: result isNotNil.
		self assert: memoryReturnedValueTarget isNotNil.
		self generateVariable: memoryReturnedValueTarget withValueType: node expectedReturnType initializationWithValue: result initialValueKind: #move.
		suppresedCleanUpTokens := { memoryReturnedValueTarget }
	].

	self withUnwindBlock: nil do: [ 
		self executeAllScopeCleanUpExceptForTokens: suppresedCleanUpTokens.
		slvmBuilder isLastTerminator ifTrue: [ ^ nil ].
		self generateAutomaticEpilogueCode.
		nonLocalReturnTargetRef ifNotNil: [ :targetContext |
			node expectedReturnType isVoidType ifFalse: [ 
				node expectedReturnType isMemoryReturnedType ifFalse: [
					self compilationTarget usesExceptionsForNonLocalReturns ifTrue: [ 
						self assert: nonLocalReturnResultRef isNotNil.
						slvmBuilder store: result in: nonLocalReturnResultRef
					] ifFalse: [
						^ slvmBuilder return: result fromContext: nonLocalReturnTargetRef
					].
				].
			].
			slvmBuilder call: codeModuleGenerator nonLocalReturnRaiseFunction arguments: { nonLocalReturnTargetRef }.
			^ slvmBuilder unreachable
		].
		node expectedReturnType isVoidType ifTrue: [
			slvmBuilder returnVoid.
			^ nil
		].

		self assert: result isNotNil.
		
		node expectedReturnType isMemoryReturnedType ifTrue: [ 
			slvmBuilder returnVoid
		] ifFalse: [
			slvmBuilder return: result
		].

		^ nil
	].

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
MbndSlovimFunctionCodeGenerator >> visitShaderEntryPointInfoReferenceNode: node [
	^ codeModuleGenerator getOrCreateShaderEntryPointInfoFor: node binding
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
MbndSlovimFunctionCodeGenerator >> visitTupleNode: node [
	| elements resultType result |
	elements := node elements collect: [ :each | self visitNode: each ].
	resultType := self translateType: node type.
	resultType isPointerType ifTrue: [ 
		self halt
	] ifFalse: [
		self assert: resultType isStructureType.
		result := SLVMConstant undefined: resultType.
		elements doWithIndex: [ :el :index |
			result := slvmBuilder insertValue: result value: el indices: { index - 1 }
		].
	].

	^ result
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
	translatedBinding isFakeValue ifTrue: [ 
		translatedBinding isMbndSlovimFoldingLiteralGlobal ifTrue: [
			translatedBinding := functionVariables at: translatedBinding ifAbsentPut: [
				| functionLocalVar constantValue |
				constantValue := translatedBinding value.
				functionLocalVar := slvmBuilder allocaBuilder alloca: constantValue type.
				entryPointLocalInitializations add: [ slvmBuilder allocaBuilder store: constantValue in: functionLocalVar ].
				functionLocalVar
			].
		].
	].

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
		slvmBuilder branch: (self visitBooleanNode: expr) ifTrue: loopBody ifFalse: loopMerge
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

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> withExceptionScope: newCleanUpScope do: aBlock [
	| oldCleanUpScope oldUnwindBlock newUnwindBlock |
	oldCleanUpScope := currentCleanUpScope.
	oldUnwindBlock := slvmBuilder currentUnwindBlock.
	newUnwindBlock := newCleanUpScope unwindBlock.
	
	currentCleanUpScope := newCleanUpScope.
	^ [
		newUnwindBlock ifNotNil: [
			slvmBuilder currentUnwindBlock: currentCleanUpScope unwindBlock
		].
	
		aBlock value.
	] ensure: [
		| normalCleanUpBlock |
		currentCleanUpScope := oldCleanUpScope.
		newUnwindBlock ifNotNil: [
			slvmBuilder currentUnwindBlock: oldUnwindBlock.
		].

		self hasExceptions ifTrue: [ 
			normalCleanUpBlock := newCleanUpScope normalCleanUpBlock.
			(normalCleanUpBlock predecessors isNotEmpty or:
			[ normalCleanUpBlock unwindBlock ~~ slvmBuilder currentBlock unwindBlock and:
			  [ slvmBuilder isLastTerminator not and: 
			  [ newCleanUpScope mustBeNopExceptionScope not ]]]) ifTrue: [
				slvmBuilder isLastTerminator ifFalse: [ 
					slvmBuilder jump: normalCleanUpBlock.
				].
				slvmBuilder currentBlock: normalCleanUpBlock.			
			] ifFalse: [ 
				normalCleanUpBlock removeFromFunction.
				newCleanUpScope normalCleanUpBlock: nil.
			].
		].

		slvmBuilder isLastTerminator ifFalse: [ 
			self executeScopeCleanUpActions: newCleanUpScope
		].
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

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> withUnwindBlock: newUnwindBlock do: aBlock [
	| oldUnwindBlock |
	oldUnwindBlock := slvmBuilder currentUnwindBlock.
	slvmBuilder currentUnwindBlock: newUnwindBlock.
	aBlock ensure: [ slvmBuilder currentUnwindBlock: oldUnwindBlock ]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> wrapValue: value withType: valueType intoDynamicObjectWithType: dynamicObjectType [
	| wrappedValue |
	self assert: dynamicObjectType isGarbageCollectedType.
	
	wrappedValue := nil.
	valueType isGarbageCollectedType ifTrue: [ 
		self flag: 'TODO: Perform a type check here.'.
		wrappedValue := value.
	].

	valueType isVoidType ifTrue: [
		wrappedValue := slvmBuilder addDynamicLiteral: nil
	].

	valueType isPrimitiveBooleanType ifTrue: [ 
		wrappedValue := slvmBuilder boolToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	valueType isPrimitiveCharacterCodeType ifTrue: [ 
		wrappedValue := slvmBuilder charToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	valueType isPrimitiveIntegerType ifTrue: [ 
		wrappedValue := slvmBuilder intToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	valueType isPrimitiveFloatType ifTrue: [ 
		wrappedValue := slvmBuilder floatToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	valueType isPointerLikeType ifTrue: [
		wrappedValue := slvmBuilder addDynamicLiteral: nil
	].

	valueType isMetaType ifTrue: [
		wrappedValue := value
	].

	wrappedValue ifNil: [ 
		self error: 'TODO: Implement this case.'
	].

	^ slvmBuilder bitCast: wrappedValue target: (self translateType: dynamicObjectType)
]
