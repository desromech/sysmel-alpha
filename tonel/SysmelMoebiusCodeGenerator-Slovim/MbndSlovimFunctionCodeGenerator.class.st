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
		'ssaFunctionEntryBlock',
		'ssaFunctionBodyBlock',
		'activeLexicalScope',
		'storageCreationNodeVariableMapForCopyEllision',
		'entryPointLocalInitializations',
		'inCleanUpContextCount',
		'nonLocalReturnContext',
		'nonLocalReturnResultVariable',
		'exceptionHandlingCodeGenerator'
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
	exceptionHandlingCodeGenerator generateCleanUpActionActivatedHereForNode: node token: localVariable asCanonicalLocalReference with: [
		self generateVariable: localVariable finalizationForValueType: valueType
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> aggregate: aggregateNode value: aggregateValue getFieldOverrideFor: field [
	| valueType referenceType |
	self slvmCompilationTarget isGPU ifFalse: [ ^ nil ].
	
	valueType := field valueType.
	referenceType := field type.
	field isDescriptorSetBinding ifTrue: [
		self assert: aggregateValue isFunctionArgument.
		^ MbndSlovimDescriptorSetReference new
			setIndex: field asDescriptorSetIndex;
			valueType: field valueType;
			yourself
	].

	field isPushConstantBinding ifTrue: [
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
	exceptionHandlingCodeGenerator generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	"concreteMethod requiresCompiledMethodMetadata ifTrue: [
		ssaFunction
			addRequiredDynamicLiteral: concreteMethod selectorRequiredLiteral;
			addRequiredDynamicLiteral: concreteMethod classBindingLiteral;
			hasSelectorAndClassBinding: true
	]."

	self cleanUpStructuredControlFlow.
	ssaFunction validate.
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
	exceptionHandlingCodeGenerator generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	self cleanUpStructuredControlFlow.
	ssaFunction validate.
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
	exceptionHandlingCodeGenerator generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	concreteMethod requiresCompiledMethodMetadata ifTrue: [
		ssaFunction
			addRequiredDynamicLiteral: concreteMethod selectorRequiredLiteral;
			addRequiredDynamicLiteral: concreteMethod classBindingLiteral;
			hasSelectorAndClassBinding: true
	].

	self cleanUpStructuredControlFlow.
	ssaFunction validate.
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

	exceptionHandlingCodeGenerator generateUnwindingCode.
	
	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: ssaFunctionBodyBlock.
	
	self cleanUpStructuredControlFlow.
	ssaFunction validate.
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
	ssaFunction validate
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> cleanUpStructuredControlFlow [
	ssaFunction basicBlocks do: [ :bb |
		self assert: bb isEmpty not.
		bb addUnreachableStructuredSuccessors
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> computePatternConstantSet: pattern [
	^ MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator new
		functionCodeGenerator: self;
		visitNode: pattern
]

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> concreteMethod [
	^ concreteMethod
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> createExceptionHandlingCodeGenerator [
	^ self codeModuleGenerator exceptionHandlingCodeGeneratorClass new
		functionCodeGenerator: self;
		yourself
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
MbndSlovimFunctionCodeGenerator >> emitPatternMatchingFailureTrap [
	self compilationTarget isGPU ifFalse: [
		slvmBuilder call: codeModuleGenerator patternMatchingFailureRaiseFunction arguments: #().
	].
	^ slvmBuilder unreachable
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> emitVariantTypeSelectorCheck: typeSelector withExpectedTypeSelector: expectedTypeSelector [
	| isMatchingTypeSelector variantTypeSelectorTrapBlock variantTypeSelectorMatchingBlock |
	isMatchingTypeSelector := slvmBuilder ieq: typeSelector with: expectedTypeSelector.
	
	variantTypeSelectorTrapBlock := slvmBuilder newBasicBlock: #variantTypeSelectorTrap.
	variantTypeSelectorMatchingBlock := slvmBuilder newBasicBlock: #variantTypeSelectorMatchingBlock.
	slvmBuilder currentBlock mergeBlock: variantTypeSelectorMatchingBlock.
	slvmBuilder branch: isMatchingTypeSelector ifTrue: variantTypeSelectorMatchingBlock ifFalse: variantTypeSelectorTrapBlock.

	slvmBuilder currentBlock: variantTypeSelectorTrapBlock.
	
	slvmBuilder call: codeModuleGenerator variantUnexpectedComponentRaiseFunction arguments: #().
	slvmBuilder unreachable.
	
	slvmBuilder currentBlock: variantTypeSelectorMatchingBlock.
	

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> executeAllScopeCleanUp [
	^ self executeAllScopeCleanUpExceptForTokens: #()
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> expandTexcoord: texcoord toCanonicalCPUTexcoordFor: textureType [
	| texcoordSize zeroVector dimensionMask arrayMask zeroMask |
	texcoordSize := texcoord type elements.
	texcoordSize = 4 ifTrue: [ ^ texcoord ].
	zeroVector := SLVMConstant zeroInitializer: texcoord type.
	
	dimensionMask := (0 to: textureType dimensionCount - 1) asArray.
	arrayMask := textureType layered
		ifTrue: [ { texcoord elements - 1 } ]
		ifFalse: [ #() ].
	zeroMask := (0 to: 4 - (dimensionMask size + arrayMask size) - 1) collect: [ :i | texcoordSize ].
	^ slvmBuilder shuffleVector: texcoord with: zeroVector components: dimensionMask , zeroMask , arrayMask
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
MbndSlovimFunctionCodeGenerator >> functionVariables [
	^ functionVariables
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAggregate: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock [
	self flag: 'TODO: Use a double dispatch here?'.
	aggregateType isAggregateTypeWithFields ifTrue: [
		^ self generateAggregateWithFields: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock
	].

	aggregateType isTupleType ifTrue: [
		^ self generateTuple: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock
	].

	aggregateType isVariantUnionType ifTrue: [
		^ self generateVariant: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock
	].
	
	aggregateType isArrayType ifTrue: [
		^ self generateArray: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock
	].

	self error: 'Unsupported aggregate type.'
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAggregate: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock [
	self flag: 'TODO: Use a double dispatch here?'.
	aggregateType isAggregateTypeWithFields ifTrue: [
		^ self generateAggregateWithFields: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock
	].

	aggregateType isTupleType ifTrue: [
		^ self generateTuple: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock
	].

	aggregateType isVariantUnionType ifTrue: [
		^ self generateVariant: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock
	].
	
	aggregateType isArrayType ifTrue: [
		^ self generateArray: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock
	].

	self error: 'Unsupported aggregate type.'
]

{ #category : #initialization }
MbndSlovimFunctionCodeGenerator >> generateAggregateWithFields: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock [
	aggregateType fields do: [ :field |
		| fieldReferenceType fieldValueType |
		fieldReferenceType := field type.
		fieldValueType := field valueType.
		
		(fieldSelectionBlock value: fieldValueType) ifTrue: [ 
			| fieldPointer |
			fieldPointer := slvmBuilder getReference: aggregatePointer element: (slvmBuilder constInt: field slotIndex).
			fieldActionBlock value: fieldPointer value: fieldReferenceType value: fieldValueType
		].
	]
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAggregateWithFields: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock [
	aggregateType fields do: [ :field |
		| fieldValueType fieldIndex fieldPointer otherFieldPointer |
		fieldValueType := field valueType.
		fieldIndex := slvmBuilder constInt: field slotIndex.
		fieldPointer := slvmBuilder getReference: aggregatePointer element: fieldIndex.
		otherFieldPointer := slvmBuilder getReference: otherAggregatePointer element: fieldIndex.
		fieldActionBlock value: fieldPointer value: otherFieldPointer value: fieldValueType
	]
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateArray: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock [
	| elementValueType elementReferenceType |
	(aggregateType elements isNil or: [ aggregateType elements <= 0 ]) ifTrue: [ ^ self ].
	elementValueType := aggregateType elementType.
	(fieldSelectionBlock value: aggregateType elementType) ifFalse: [ ^ self ].

	elementReferenceType := elementValueType ref.
	self generateFrom: 0 to: aggregateType elements - 1 do: [ :index |
		| fieldPointer|
		fieldPointer := slvmBuilder getReference: aggregatePointer element: index.
		fieldActionBlock value: fieldPointer value: elementReferenceType value: elementValueType
	]
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateArray: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock [
	| elementValueType |
	(aggregateType elements isNil or: [ aggregateType elements <= 0 ]) ifTrue: [ ^ self ].
	elementValueType := aggregateType elementType.
	self generateFrom: 0 to: aggregateType elements - 1 do: [ :index |
		| fieldPointer otherFieldPointer |
		fieldPointer := slvmBuilder getReference: aggregatePointer element: index.
		otherFieldPointer := slvmBuilder getReference: otherAggregatePointer element: index.
		fieldActionBlock value: fieldPointer value: otherFieldPointer value: elementValueType
	]
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticCopyAssignmentCode [
	| receiver other |
	receiver := ssaFunction arguments first.
	other := ssaFunction arguments second.

	concreteMethod parent supertype ifNotNil: [ :supertype |
		supertype isTrait ifFalse: [ 
			self generateInstanceCopyFrom: (slvmBuilder bitCast: other target: (self translateType: supertype ref))
				into: (slvmBuilder bitCast: receiver target: (self translateType: supertype ref))
				valueType: supertype.
		]
	].

	self generateAggregate: receiver with: other type: concreteMethod parent
		fieldIteration: [ :receiverFieldPointer :otherFieldPointer :fieldValueType |
			self generateCopyFrom: otherFieldPointer into: receiverFieldPointer valueType: fieldValueType
	].
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticEpilogueCode [
	concreteMethod ifNil: [ ^ self ].
	(concreteMethod isMessageMethod and: [ concreteMethod name = #finalize and: [concreteMethod hasExplicitSuperSend not ]]) ifTrue: [
		self generateAutomaticFinalizationCode
	].
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFieldFinalization: fieldPointer type: referenceType valueType: valueType [
	| finalizeMethod |
	valueType hasTrivialFinalization ifTrue: [ ^ self ].
	
	finalizeMethod := valueType finalizeMethod.
	self generateCallWithReceiver: fieldPointer receiverType: valueType selector: #finalize arguments: #()
		isSuperSend: false declaredMethod: finalizeMethod expectedResultType: finalizeMethod returnType
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFieldInitialization: fieldPointer type: referenceType valueType: valueType [
	| finalizeMethod |
	valueType hasTrivialInitialization ifTrue: [ ^ self ].
	
	finalizeMethod := valueType initializeMethod.
	self generateCallWithReceiver: fieldPointer receiverType: valueType selector: #initialize arguments: #()
		isSuperSend: false declaredMethod: finalizeMethod expectedResultType: finalizeMethod returnType
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticFinalizationCode [
	| receiver superFinalize |
	receiver := ssaFunction arguments first.
	self generateAggregate: receiver type: concreteMethod parent
		fieldIteration: [ :fieldPointer :fieldReferenceType :fieldValueType |
		self generateAutomaticFieldFinalization: fieldPointer type: fieldReferenceType valueType: fieldValueType
	] when: [ :fieldType | fieldType hasTrivialFinalization not ].

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

{ #category : #'automatic constructors' }
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


	self generateAggregate: receiver type: concreteMethod parent
		fieldIteration: [ :fieldPointer :fieldReferenceType :fieldValueType |
		self generateAutomaticFieldInitialization: fieldPointer type: fieldReferenceType valueType: fieldValueType
	] when: [ :fieldType | fieldType hasTrivialInitialization not ].
	
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticInitializationFromCopyCode [
	| receiver other |
	receiver := ssaFunction arguments first.
	other := ssaFunction arguments second.
	concreteMethod parent hasTrivialInstanceInitializationCopyingFrom ifTrue: [ 
		^ self generateTrivialCopyFrom: other into: receiver valueType: concreteMethod parent.
	].
	
	concreteMethod hasExplicitSuperSend ifFalse: [
		concreteMethod parent supertype ifNotNil: [ :supertype |
			supertype isTrait ifFalse: [ 
				supertype hasTrivialInitializationCopyingFrom ifTrue: [
					self generateTrivialCopyFrom: (slvmBuilder bitCast: other target: (self translateType: supertype ref))
						into: (slvmBuilder bitCast: receiver target: (self translateType: supertype ref))
						valueType: supertype.
				] ifFalse: [
					|superCopyMethod|
					superCopyMethod := supertype initializeCopyingFromMethod.
					self generateCallWithReceiver: (slvmBuilder bitCast: receiver target: (self translateType: superCopyMethod receiverType))
						receiverType: superCopyMethod receiverType
						selector: #initializeCopyingFrom: arguments: {
							(slvmBuilder bitCast: other target: (self translateType: superCopyMethod boundType argumentTypes first))
						} isSuperSend: true declaredMethod: superCopyMethod
						expectedResultType: superCopyMethod returnType
				]
			]
		]
	].

	self generateAggregate: receiver with: other type: concreteMethod parent
		fieldIteration: [ :receiverFieldPointer :otherFieldPointer :fieldValueType |
		fieldValueType hasTrivialInitializationCopyingFrom ifTrue: [ 
			slvmBuilder store: (slvmBuilder load: otherFieldPointer) in: receiverFieldPointer
		] ifFalse: [ 
			self generateVariable: receiverFieldPointer withValueType: fieldValueType initializationWithValue: otherFieldPointer initialValueKind: #copy
		].
	].
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticInitializationMovingFromCode [
	| receiver other |
	concreteMethod parent hasTrivialInstanceInitializationMovingFrom ifTrue: [ 
		^ self generateAutomaticInitializationFromCopyCode.
	].

	receiver := ssaFunction arguments first.
	other := ssaFunction arguments second.
	
	concreteMethod hasExplicitSuperSend ifFalse: [
		concreteMethod parent supertype ifNotNil: [ :supertype |
			supertype isTrait ifFalse: [ 
				(supertype hasTrivialInitializationCopyingFrom and: [supertype hasTrivialInitializationMovingFrom ]) ifTrue: [
					self generateTrivialCopyFrom: (slvmBuilder bitCast: other target: (self translateType: supertype ref))
						into: (slvmBuilder bitCast: receiver target: (self translateType: supertype ref))
						valueType: supertype.
				] ifFalse: [
					| superMoveMethod selector |
					supertype hasTrivialInitializationMovingFrom ifTrue: [ 
						selector := #initializeCopyingFrom:.
						superMoveMethod := supertype initializeCopyingFromMethod.
					] ifFalse: [ 
						selector := #initializeMovingFrom:.
						superMoveMethod := supertype initializeMovingFromMethod.
					].
					self generateCallWithReceiver: (slvmBuilder bitCast: receiver target: (self translateType: superMoveMethod receiverType))
						receiverType: superMoveMethod receiverType
						selector: selector arguments: {
							(slvmBuilder bitCast: other target: (self translateType: superMoveMethod boundType argumentTypes first))
						} isSuperSend: true declaredMethod: superMoveMethod
						expectedResultType: superMoveMethod returnType
				]
			]
		]
	].

	self generateAggregate: receiver with: other type: concreteMethod parent
		fieldIteration: [ :receiverFieldPointer :otherFieldPointer :fieldValueType |
		(fieldValueType hasTrivialInitializationCopyingFrom and: [ fieldValueType hasTrivialInitializationMovingFrom ]) ifTrue: [ 
			slvmBuilder store: (slvmBuilder load: otherFieldPointer) in: receiverFieldPointer
		] ifFalse: [ 
			self generateVariable: receiverFieldPointer withValueType: fieldValueType initializationWithValue: otherFieldPointer initialValueKind: #move
		].

	].
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateAutomaticMoveAssignmentCode [
	| receiver other |
	receiver := ssaFunction arguments first.
	other := ssaFunction arguments second.

	concreteMethod parent supertype ifNotNil: [ :supertype |
		supertype isTrait ifFalse: [ 
			self generateInstanceMoveFrom: (slvmBuilder bitCast: other target: (self translateType: supertype ref))
				into: (slvmBuilder bitCast: receiver target: (self translateType: supertype ref))
				valueType: supertype.
		]
	].

	self generateAggregate: receiver with: other type: concreteMethod parent
		fieldIteration: [ :receiverFieldPointer :otherFieldPointer :fieldValueType |
			self generateMoveFrom: otherFieldPointer into: receiverFieldPointer valueType: fieldValueType
	].
]

{ #category : #'automatic constructors' }
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
			self assert: memoryReturnTemporary isNotNil.
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
	expectedResultType isMemoryReturnedType ifTrue: [ result setSRetPresence ].
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
		result type ~= expectedResultSSAType ifTrue: [ 
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
			self assert: memoryReturnTemporary isNotNil.
			actualReturnType := SLVMType voidType.
			out nextPut: memoryReturnTemporary
		].
	
		receiver ifNotNil: [
			out nextPut: receiver
		].
		out nextPutAll: arguments
	].

	calledMethodSSAFunction := (self translateProgramEntity: declaredMethod) ssaValue.
	hasStaticBinding := (declaredMethod hasFlag: #staticBinding) or: [declaredMethod isSealed].
	
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
		allArguments := arguments.
		expectedResultType isMemoryReturnedType ifTrue: [
			self assert: memoryReturnTemporary isNotNil.
			allArguments := {memoryReturnTemporary} , allArguments
		].
	
		selectorValue isSymbol ifTrue: [ selectorValue := slvmBuilder addDynamicLiteral: selectorValue ].

		self assert: selectorValue type isDynamicObjectPointerType.
		result := slvmBuilder send: selectorValue returnType: actualReturnType receiver: receiver arguments: allArguments.
		result highLevelMessageSendFunctionType: declaredMethod type asCanonicalMessageSendFunctionType.
		isSuperSend ifTrue: [
			result setSuperSend
		].
		expectedResultType isMemoryReturnedType ifTrue: [
			result setSRetPresence
		].
	] ifFalse: [
		result := slvmBuilder call: calledMethodSSAFunction arguments: allArguments.
		expectedResultType isMemoryReturnedType ifTrue: [ result setSRetPresence ].
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
		result type ~= expectedResultSSAType ifTrue: [ 
			self assert: (result type isPointerType and: [ expectedResultSSAType isPointerType ]).
			result := slvmBuilder bitCast: result target: expectedResultSSAType
		].
	].

	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCase: case withMatchedValue: matchedValue [
	self generatePattern: case pattern matchingBindingWithValue: matchedValue.
	^ self visitNode: case action
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCase: case withMatchedValue: matchedValue temporaryResult: temporaryResult resultType: resultType [
	| result |
	self generatePattern: case pattern matchingBindingWithValue: matchedValue.
	result := self visitNode: case action.
	
	temporaryResult ifNotNil: [
		self assert: resultType isTemporaryReferenceType.
		slvmBuilder isLastTerminator ifFalse: [ 
			self generateVariable: temporaryResult withValueType: resultType baseType initializationWithValue: result
				initialValueKind: (case action type isTemporaryReferenceType ifTrue: [#move] ifFalse: [#copy]).
		].
	
		result := temporaryResult
	].
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream [
	| currentCase |
	currentCase := caseStream peek.
	matchedValue type isIntegerType ifTrue: [
		| literalCases |
		literalCases := Array streamContents: [ :out |
			| constantSet |
			[ currentCase isNotNil and: [ (constantSet := self computePatternConstantSet: currentCase pattern) isNotEmpty ] ] whileTrue: [ 
				out nextPut: {caseStream next . constantSet}.
				currentCase := caseStream peek.
			]
		].
	
		literalCases ifNotEmpty: [
			^ self generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream literalIntegerCases: literalCases
		]
	].

	currentCase ifNil: [ ^ self emitPatternMatchingFailureTrap ].
	currentCase hasDefaultPattern ifTrue: [
		^ self generateCase: currentCase withMatchedValue: matchedValue temporaryResult: temporaryResult resultType: node type
	].

	caseStream next.
	^ self generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream ifCascadeCase: currentCase
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream ifCascadeCase: case [
	| isPatternMatched patternMatchedBlock nextPatternBlock mergeBlock patternMatchedResult patternMatchedResultBlock nextPatternResult nextPatternResultBlock phi |

	patternMatchedBlock := slvmBuilder newBasicBlock: #patternMatched.
	nextPatternBlock := slvmBuilder newBasicBlock: #nextPatternTesting.
	mergeBlock := slvmBuilder newBasicBlock: #mergeBlock.
	slvmBuilder currentBlock mergeBlock: mergeBlock.

	isPatternMatched := self generatePattern: case pattern matchingWithValue: matchedValue nextPatternBlock: nextPatternBlock.

	slvmBuilder branch: isPatternMatched ifTrue: patternMatchedBlock ifFalse: nextPatternBlock.
	
	slvmBuilder currentBlock: patternMatchedBlock.
	patternMatchedResult := self generateCase: case withMatchedValue: matchedValue temporaryResult: temporaryResult resultType: node type.
	patternMatchedResultBlock := nil.
	
	slvmBuilder isLastTerminator ifFalse: [
		patternMatchedResultBlock := slvmBuilder currentBlock.
		slvmBuilder jump: mergeBlock.
	].
	
	"Generate the next patterns."
	slvmBuilder currentBlock: nextPatternBlock.
	nextPatternResult := self generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream.
	nextPatternResultBlock := nil.
	slvmBuilder isLastTerminator ifFalse: [
		nextPatternResultBlock := slvmBuilder currentBlock.
		slvmBuilder jump: mergeBlock.
	].

	"Merge the control flow."
	slvmBuilder currentBlock: mergeBlock.
	mergeBlock predecessors ifEmpty: [
		mergeBlock unreachable.
	].

	temporaryResult ifNotNil: [
		^ temporaryResult
	].

	node type isVoidType ifTrue: [ ^ nil ].
	
	phi := slvmBuilder phi: (self translateType: node type).
	patternMatchedResultBlock ifNotNil: [ 
		phi addValue: patternMatchedResult from: patternMatchedResultBlock
	].
	nextPatternResultBlock ifNotNil: [ 
		phi addValue: nextPatternResult from: nextPatternResultBlock
	].

	^ phi
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream literalIntegerCases: literalCases [
	| caseConstants caseConstantBlocks caseBlocks defaultBlock mergeBlock switchBlock generatedConstants mergeValue caseValue |
	caseBlocks := literalCases collect: [ :case | slvmBuilder newBasicBlock: #casesOfCase ].
	caseConstants := OrderedCollection new.
	caseConstantBlocks := OrderedCollection new.
	generatedConstants := Set new.
	literalCases doWithIndex: [ :caseAndConstantSet :index |
		| block |
		block := caseBlocks at: index.
		caseAndConstantSet second do: [ :literalConstant |
		    (generatedConstants includes: literalConstant) ifFalse: [ 
		        generatedConstants add: literalConstant.
		        caseConstants add: literalConstant.
		        caseConstantBlocks add: block
		    ].
		]
	].

	defaultBlock := slvmBuilder newBasicBlock: #casesOfDefault.
	mergeBlock := slvmBuilder newBasicBlock: #casesOfMerge.

	switchBlock := slvmBuilder currentBlock.
	slvmBuilder currentBlock mergeBlock: mergeBlock.
	slvmBuilder switch: matchedValue caseConstants: caseConstants asArray caseBlocks: caseConstantBlocks asArray defaultBlock: defaultBlock.
	(node type isVoidType not and: [ temporaryResult isNil ]) ifTrue: [
		slvmBuilder currentBlock: mergeBlock.
		mergeValue := slvmBuilder phi: (self translateType: node type) name: #casesResult
	].

	"Generate the literal cases."
	literalCases doWithIndex: [ :caseAndConstantSet :index |
		slvmBuilder currentBlock: (caseBlocks at: index).
		caseValue := self generateCase: caseAndConstantSet first withMatchedValue: matchedValue temporaryResult: temporaryResult resultType: node type.
		slvmBuilder isLastTerminator ifFalse: [
		    mergeValue ifNotNil: [
		        mergeValue addValue: caseValue from: slvmBuilder currentBlock.
		    ].
		    slvmBuilder jump: mergeBlock
		]
	].

	"Generate the default case."
	slvmBuilder currentBlock: defaultBlock.
	caseValue := self generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: caseStream.

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

	^ temporaryResult ifNil: [mergeValue]
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateCopyFrom: sourcePointer into: targetPointer valueType: valueType [
	valueType hasTrivialCopyAssignment ifTrue: [ 
		^ self generateTrivialCopyFrom: sourcePointer into: targetPointer valueType: valueType
	].

	^ self generateNonTrivialCopyFrom: sourcePointer into: targetPointer superSend: false valueType: valueType
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateElementWiseThreeWayComparisonOf: rawLeftOperand with: rawRightOperand resultType: resultType [
	| leftOperand rightOperand operandType elementType rawOperandType |
	leftOperand := rawLeftOperand.
	rightOperand := rawRightOperand.
	rawOperandType := leftOperand type.
	operandType := rawOperandType.
	elementType := operandType.
	(elementType isVectorType or: [ elementType isMatrixType ]) ifTrue: [ 
		elementType := elementType baseType
	].
	
	elementType isPointerType ifTrue: [ 
		operandType := self translateType: self compilationTarget intPointerType.
		leftOperand := slvmBuilder pointerToIntCast: leftOperand target: operandType.
		rightOperand := slvmBuilder pointerToIntCast: rightOperand target: operandType.
	].

	elementType isBooleanType ifTrue: [ 
		leftOperand := slvmBuilder zeroExtend: leftOperand target: resultType.
		rightOperand := slvmBuilder zeroExtend: rightOperand target: resultType.
		^ slvmBuilder sub: leftOperand with: rightOperand
	].

	elementType isIntegerType ifTrue: [
		| result |
		result := slvmBuilder sub: leftOperand with: rightOperand.
		result type ~= resultType ifTrue: [
			result type size = resultType size ifTrue: [
				result := slvmBuilder bitCast: result target: resultType
			] ifFalse: [
				result type size < resultType size ifTrue: [ 
					result := slvmBuilder signExtend: result target: resultType
				] ifFalse: [ 
					result := slvmBuilder truncate: result target: resultType
				]
			]
		].
		^ result
	].

	elementType isFloatType ifTrue: [
		| result signIntrinsic |
		result := slvmBuilder fsub: leftOperand with: rightOperand.
		signIntrinsic := self codeModuleGenerator intrinsicConstantBuiltInFunction: #'math.fsign' withSSAFunctionType: (SLVMFunctionType arguments: {operandType} returnType: operandType).
		result := slvmBuilder call: signIntrinsic arguments: { result }.
		^ slvmBuilder floatToIntCast: result target: resultType.
	].

	self error
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

{ #category : #'code generation' }
MbndSlovimFunctionCodeGenerator >> generateFrom: startIndex to: stopIndex do: aBlock [
	self assert: startIndex isInteger.
	self assert: stopIndex isInteger.
	self flag: 'TODO: Do not unroll this with large indices.'.
	startIndex to: stopIndex do: [ :i |
		aBlock value: (slvmBuilder constInt: i)
	]
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
MbndSlovimFunctionCodeGenerator >> generateIndex: index sizeBoundsCheck: sizeValueBlock [
	| sizeValue outOfBoundsRaiseFunction inBounds boundsCheckTrap boundsCheckMerge |
	self compilationTarget hasBoundsChecks ifFalse: [ ^ self ].
	self compilationEnvironment hasExceptions ifFalse: [ ^ self ].
	
	sizeValue := sizeValueBlock value.
	(index isConstantValue and: [ sizeValue isConstantValue and: [index value < sizeValue value]]) ifTrue: [ ^ self ].
	outOfBoundsRaiseFunction := self codeModuleGenerator indexOutOfBoundsRaiseFunction.
	outOfBoundsRaiseFunction ifNil: [ ^ self ].
	inBounds := slvmBuilder ilt: (slvmBuilder intCast: index target: sizeValue type) with: sizeValue.
	
	boundsCheckTrap := slvmBuilder newBasicBlock: #boundsCheckTrap.
	boundsCheckMerge := slvmBuilder newBasicBlock: #boundsCheckMerge.
	slvmBuilder currentBlock mergeBlock: boundsCheckMerge.
	slvmBuilder branch: inBounds ifTrue: boundsCheckMerge ifFalse: boundsCheckTrap.
	
	"Trap"
	slvmBuilder currentBlock: boundsCheckTrap.
	
	slvmBuilder call: outOfBoundsRaiseFunction arguments: {
		slvmBuilder intCast: index target: outOfBoundsRaiseFunction functionType arguments first.
		slvmBuilder intCast: sizeValue target: outOfBoundsRaiseFunction functionType arguments second.
	}.
	slvmBuilder unreachable.

	"Bounds check success"
	slvmBuilder currentBlock: boundsCheckMerge.

]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateInstanceCopyFrom: sourcePointer into: targetPointer valueType: valueType [
	valueType hasTrivialInstanceCopyAssignment ifTrue: [ 
		^ self generateTrivialCopyFrom: sourcePointer into: targetPointer valueType: valueType
	].

	^ self generateNonTrivialCopyFrom: sourcePointer into: targetPointer superSend: true valueType: valueType
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateInstanceMoveFrom: sourcePointer into: targetPointer valueType: valueType [
	valueType hasTrivialInstanceMoveAssignment ifTrue: [ 
		^ self generateInstanceCopyFrom: sourcePointer into: targetPointer valueType: valueType
	].

	^ self generateNonTrivialMoveFrom: sourcePointer into: targetPointer superSend: true valueType: valueType
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

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateMoveFrom: sourcePointer into: targetPointer valueType: valueType [
	valueType hasTrivialMoveAssignment ifTrue: [ 
		^ self generateCopyFrom: sourcePointer into: targetPointer valueType: valueType
	].

	^ self generateNonTrivialMoveFrom: sourcePointer into: targetPointer superSend: false valueType: valueType
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateNonTrivialCopyFrom: sourcePointer into: targetPointer superSend: isSuperSend valueType: valueType [
	| copyAssignmentMethod |
	copyAssignmentMethod := valueType copyAssignmentMethod.
	self generateCallWithReceiver: (slvmBuilder bitCast: targetPointer target: (self translateType: copyAssignmentMethod receiverType))
			receiverType: copyAssignmentMethod receiverType
			selector: #assignValue: arguments: {
				(slvmBuilder bitCast: sourcePointer target: (self translateType: copyAssignmentMethod boundType argumentTypes first))
			} isSuperSend: true declaredMethod: copyAssignmentMethod
		expectedResultType: copyAssignmentMethod returnType
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateNonTrivialMoveFrom: sourcePointer into: targetPointer superSend: isSuperSend valueType: valueType [
	| moveAssignmentMethod |
	moveAssignmentMethod := valueType moveAssignmentMethod.
	self generateCallWithReceiver: (slvmBuilder bitCast: targetPointer target: (self translateType: moveAssignmentMethod receiverType))
			receiverType: moveAssignmentMethod receiverType
			selector: #assignValue: arguments: {
				(slvmBuilder bitCast: sourcePointer target: (self translateType: moveAssignmentMethod boundType argumentTypes first))
			} isSuperSend: true declaredMethod: moveAssignmentMethod
		expectedResultType: moveAssignmentMethod returnType
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generatePattern: pattern matchingBindingWithValue: matchedValue [
	^ MbndSlovimFunctionPatternMatchingBindingCodeGenerator new
		functionCodeGenerator: self;
		matchedValue: matchedValue;
		visitNode: pattern
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generatePattern: pattern matchingWithValue: matchedValue [
	^ self generatePattern: pattern matchingWithValue: matchedValue nextPatternBlock: nil
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generatePattern: pattern matchingWithValue: matchedValue nextPatternBlock: nextPatternBlock [
	^ MbndSlovimFunctionPatternMatchingTestingCodeGenerator new
		functionCodeGenerator: self;
		matchedValue: matchedValue;
		nextPatternBlock: nextPatternBlock;
		visitNode: pattern
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generatePatternNotMatchedTrap: isPatternMatched [
	| trapBlock successBlock |
	self assert: isPatternMatched type isBooleanType.
	isPatternMatched isConstantValue ifTrue: [
		"The not matched case is a compilation error." 
		self assert: isPatternMatched value.
		^ self
	].

	trapBlock := slvmBuilder newBasicBlock: #patternMatchingFailureTrap.
	successBlock := slvmBuilder newBasicBlock: #patternMatchingSuccess.
	slvmBuilder currentBlock mergeBlock: successBlock.
	slvmBuilder branch: isPatternMatched ifTrue: successBlock ifFalse: trapBlock.

	slvmBuilder currentBlock: trapBlock.
	self emitPatternMatchingFailureTrap.

	slvmBuilder currentBlock: successBlock.

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
MbndSlovimFunctionCodeGenerator >> generateThreeWayComparisonOf: leftOperand with: rightOperand resultType: resultType [
	| operandType columnsComparisons columnsComparisonVector |
	operandType := leftOperand type.
	(operandType isVectorType or: [ operandType isMatrixType ]) ifFalse: [ 
		^ self generateElementWiseThreeWayComparisonOf: leftOperand with: rightOperand resultType: resultType.
	].

	(resultType isVectorType or: [ resultType isMatrixType ]) ifTrue: [ 
		^ self generateElementWiseThreeWayComparisonOf: leftOperand with: rightOperand resultType: resultType.
	].

	operandType isVectorType ifTrue: [ 
		^ self generateThreeWayComparisonOfVector: leftOperand with: rightOperand resultType: resultType
	].

	self assert: operandType isMatrixType.
	self assert: leftOperand type = rightOperand type.
	self assert: resultType isIntegerType.
	columnsComparisons := (0 to: operandType columns - 1 ) collect: [ :columnIndex |
		| leftColumn rightColumn |
		leftColumn := slvmBuilder extractValue: leftOperand indices: { columnIndex }.
		rightColumn := slvmBuilder extractValue: rightOperand indices: { columnIndex }.
		self generateThreeWayComparisonOfVector: leftColumn with: rightColumn resultType: resultType
	].

	columnsComparisonVector := slvmBuilder makeVector: (SLVMVectorType baseType: resultType elements: columnsComparisons size) arguments: columnsComparisons.
	columnsComparisonVector := self generateVectorSign: columnsComparisonVector.
	^ self vectorThreeWayComparisonResultMerge: columnsComparisonVector
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateThreeWayComparisonOfVector: leftOperand with: rightOperand resultType: resultType [
	| operandType elementWiseResultType elementWiseResult |
	operandType := leftOperand type.
	elementWiseResultType := resultType withRankOf: operandType.
	self assert: elementWiseResultType isNotNil.
	elementWiseResult := self generateElementWiseThreeWayComparisonOf: leftOperand with: rightOperand resultType: elementWiseResultType.
	operandType baseType isFloatType ifFalse: [
		elementWiseResult := self generateVectorSign: elementWiseResult
	].
	
	^ self vectorThreeWayComparisonResultMerge: elementWiseResult
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateTrivialCopyFrom: sourcePointer into: targetPointer valueType: valueType [
	valueType hasTrivialBasicInitialization ifTrue: [ 
		^ slvmBuilder store: (slvmBuilder load: sourcePointer) in: targetPointer
	].

	self generateAggregate: targetPointer with: sourcePointer type: valueType
		fieldIteration: [ :targetFieldPointer :sourceFieldPointer :fieldValueType |
			slvmBuilder store: (slvmBuilder load: sourceFieldPointer) in: targetFieldPointer
	].
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateTuple: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock [
	aggregateType elements doWithIndex: [ :elementValueType :index |
		(fieldSelectionBlock value: elementValueType) ifTrue: [ 
			| fieldPointer |
			fieldPointer := slvmBuilder getReference: aggregatePointer element: (slvmBuilder constInt: index - 1).
			fieldActionBlock value: fieldPointer value: elementValueType ref value: elementValueType
		].
	]
]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateTuple: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock [
	aggregateType elements doWithIndex: [ :fieldValueType :index |
		| fieldIndex fieldPointer otherFieldPointer |
		fieldIndex := (slvmBuilder constInt: index - 1).
		
		fieldPointer := slvmBuilder getReference: aggregatePointer element: fieldIndex.
		otherFieldPointer := slvmBuilder getReference: otherAggregatePointer element: fieldIndex.
		fieldActionBlock value: fieldPointer value: otherFieldPointer value: fieldValueType
	]
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
MbndSlovimFunctionCodeGenerator >> generateVariable: ssaValue initializationWithValueType: valueType [
	self halt
	
	"generateVariable: ssaValue withValueType: valueType initializationWithValue: initialValue initialValueKind: initialValueKind"
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

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateVariant: aggregatePointer type: aggregateType fieldIteration: fieldActionBlock when: fieldSelectionBlock [
	| interestingTypes interestingConstants interestingBlocks mergeBlock typeSelector |
	interestingTypes := OrderedCollection new.
	interestingConstants := OrderedCollection new.
	interestingBlocks := OrderedCollection new.
	aggregateType components doWithIndex: [ :each :index |
		(fieldSelectionBlock value: each) ifTrue: [
			interestingTypes add: each.
			interestingConstants add: (slvmBuilder constUChar: index - 1).
			interestingBlocks add: (slvmBuilder newBasicBlock: #variantTypeCase).
		]
	].

	interestingTypes ifEmpty: [ ^ self ].
	
	typeSelector := slvmBuilder load: (slvmBuilder getReference: aggregatePointer element: (slvmBuilder constInt: 0)).
	mergeBlock := slvmBuilder newBasicBlock: #mergeBlock.
	slvmBuilder currentBlock mergeBlock: mergeBlock.
	
	slvmBuilder switch: typeSelector caseConstants: interestingConstants asArray caseBlocks: interestingBlocks asArray defaultBlock: mergeBlock.
	
	interestingTypes doWithIndex: [ :variantValueType :caseIndex |
		| variantReferenceType typeSelectorValue fieldPointer |
		variantReferenceType := variantValueType ref.
		slvmBuilder currentBlock: (interestingBlocks at: caseIndex).
		typeSelectorValue := (interestingConstants at: caseIndex) value.
		
		fieldPointer := slvmBuilder getPointer: aggregatePointer element: {
			"Variant itself" slvmBuilder constInt: 0.
			"Union" slvmBuilder constInt: 1.
			"Union field" slvmBuilder constInt: typeSelectorValue.
		}.
		
		fieldActionBlock value: fieldPointer value: variantReferenceType value: variantValueType.
		
		slvmBuilder isLastTerminator ifFalse: [
			slvmBuilder jump: mergeBlock
		]
	].

	slvmBuilder currentBlock: mergeBlock.

]

{ #category : #'automatic constructors' }
MbndSlovimFunctionCodeGenerator >> generateVariant: aggregatePointer with: otherAggregatePointer type: aggregateType fieldIteration: fieldActionBlock [
	| interestingTypes interestingConstants interestingBlocks mergeBlock typeSelector typeSelectorPointer otherTypeSelectorPointer oldTypeSelector changedTypeSelector |
	interestingTypes := OrderedCollection new.
	interestingConstants := OrderedCollection new.
	interestingBlocks := OrderedCollection new.
	aggregateType components doWithIndex: [ :each :index |
		interestingTypes add: each.
		interestingConstants add: (slvmBuilder constUChar: index - 1).
		interestingBlocks add: (slvmBuilder newBasicBlock: #variantTypeCase).
	].

	interestingTypes ifEmpty: [ ^ self ].

	typeSelectorPointer := slvmBuilder getReference: aggregatePointer element: (slvmBuilder constInt: 0).
	otherTypeSelectorPointer := slvmBuilder getReference: otherAggregatePointer element: (slvmBuilder constInt: 0).

	typeSelector := slvmBuilder load: otherTypeSelectorPointer.
	oldTypeSelector := slvmBuilder load: typeSelectorPointer.
	changedTypeSelector := slvmBuilder ine: oldTypeSelector with: typeSelector.
	"If we have a non-trivial finalization, then we have to finalize before."
	aggregateType hasTrivialFinalization ifFalse: [
		| oldTypeFinalizationBlock oldTypeFinalizationBlockMerge|
		oldTypeFinalizationBlock := slvmBuilder newBasicBlock: #oldTypeFinalization.
		oldTypeFinalizationBlockMerge := slvmBuilder newBasicBlock: #oldTypeFinalizationMerge.
		slvmBuilder currentBlock mergeBlock: oldTypeFinalizationBlockMerge.
		slvmBuilder branch: changedTypeSelector ifTrue: oldTypeFinalizationBlock ifFalse: oldTypeFinalizationBlockMerge.
		slvmBuilder currentBlock: oldTypeFinalizationBlock.
		
		self generateAggregate: aggregatePointer type: aggregateType
			fieldIteration: [ :fieldPointer :fieldReferenceType :fieldValueType |
			self generateAutomaticFieldFinalization: fieldPointer type: fieldReferenceType valueType: fieldValueType
		] when: [ :fieldType | fieldType hasTrivialFinalization not ].

		slvmBuilder isLastTerminator ifFalse: [
			slvmBuilder jump: oldTypeFinalizationBlockMerge
		].
		slvmBuilder currentBlock: oldTypeFinalizationBlockMerge.
	].

	fieldActionBlock value: typeSelectorPointer value: otherTypeSelectorPointer value: self compilationTarget uint8Type.

	mergeBlock := slvmBuilder newBasicBlock: #mergeBlock.
	slvmBuilder currentBlock mergeBlock: mergeBlock.
	
	slvmBuilder switch: typeSelector caseConstants: interestingConstants asArray caseBlocks: interestingBlocks asArray defaultBlock: mergeBlock.
	
	interestingTypes doWithIndex: [ :variantValueType :caseIndex |
		| typeSelectorValue fieldPointer otherFieldPointer |
		slvmBuilder currentBlock: (interestingBlocks at: caseIndex).
		typeSelectorValue := (interestingConstants at: caseIndex) value.
		
		fieldPointer := slvmBuilder getPointer: aggregatePointer element: {
			"Variant itself" slvmBuilder constInt: 0.
			"Union" slvmBuilder constInt: 1.
			"Union field" slvmBuilder constInt: typeSelectorValue.
		}.
		otherFieldPointer := slvmBuilder getPointer: otherAggregatePointer element: {
			"Variant itself" slvmBuilder constInt: 0.
			"Union" slvmBuilder constInt: 1.
			"Union field" slvmBuilder constInt: typeSelectorValue.
		}.
		
		"If we are changing the variant value type, we may need to perform a basic initialization
		 before an actual initialization."
		variantValueType isPOD ifFalse: [
			| newTypeBasicInitializationBlock newTypeBasicInitializationBlockMerge|
			newTypeBasicInitializationBlock := slvmBuilder newBasicBlock: #newTypeBasicInitialization.
			newTypeBasicInitializationBlockMerge := slvmBuilder newBasicBlock: #newTypeBasicInitializationMerge.
			slvmBuilder currentBlock mergeBlock: newTypeBasicInitializationBlockMerge.
			slvmBuilder branch: changedTypeSelector ifTrue: newTypeBasicInitializationBlock ifFalse: newTypeBasicInitializationBlockMerge.
			slvmBuilder currentBlock: newTypeBasicInitializationBlock.

			self generateVariable: fieldPointer basicInitializationWithValueType: variantValueType.
			
			slvmBuilder isLastTerminator ifFalse: [
				slvmBuilder jump: newTypeBasicInitializationBlockMerge
			].
			slvmBuilder currentBlock: newTypeBasicInitializationBlockMerge.
		].
	
		fieldActionBlock value: fieldPointer value: otherFieldPointer value: variantValueType.
		
		slvmBuilder isLastTerminator ifFalse: [
			slvmBuilder jump: mergeBlock
		]
	].

	slvmBuilder currentBlock: mergeBlock.

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

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> generateVectorSign: vector [
	| vectorElementType signIntrinsic vectorType |
	vectorType := vector type.
	vectorElementType := vectorType.
	(vectorElementType isVectorType or: [ vectorElementType isMatrixType ]) ifTrue: [
		vectorElementType := vectorElementType baseType.
	].

	signIntrinsic := self codeModuleGenerator intrinsicConstantBuiltInFunction:
		(vectorElementType isFloatType ifTrue: [#'math.fsign'] ifFalse: [ #'math.ssign' ])
		withSSAFunctionType: (SLVMFunctionType arguments: {vectorType} returnType: vectorType).
	^ slvmBuilder call: signIntrinsic arguments: { vector }.
]

{ #category : #testing }
MbndSlovimFunctionCodeGenerator >> hasExceptions [
	^ codeModuleGenerator hasExceptions
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

	nonLocalReturnContext := exceptionHandlingCodeGenerator generateNonLocalReturnContext.
	nonLocalReturnResultVariable := nil.
	functionVariables at: nonLocalReturnTargetVar put: nonLocalReturnContext.
	
	concreteMethod getNonLocalResultVariable ifNotNil: [ :var |
		ssaFunction functionType returnType isVoidType ifTrue: [
			concreteMethod returnType isMemoryReturnedType ifTrue: [
				nonLocalReturnResultVariable := ssaFunction arguments first.
			].
		] ifFalse: [ 
			nonLocalReturnResultVariable := slvmBuilder allocaBuilder alloca: (self sanitizeValueTypeForMemory: ssaFunction functionType returnType)
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

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> nonLocalReturnContext [
	^ nonLocalReturnContext
]

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> nonLocalReturnResultVariable [
	^ nonLocalReturnResultVariable
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
		(value type isVectorType and: [expectedType isVectorType]) ifTrue: [ 
			(expectedType baseType isBooleanType and: [ value type baseType isIntegerType ]) ifTrue: [ 
				^ slvmBuilder truncate: value target: expectedType
			].
	
			(expectedType baseType isIntegerType and: [ value type baseType isBooleanType ]) ifTrue: [ 
				^ slvmBuilder zeroExtend: value target: expectedType
			].
		].
	
		(expectedType isBooleanType and: [ value type isIntegerType ]) ifTrue: [ 
			^ slvmBuilder truncate: value target: expectedType
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

{ #category : #initialization }
MbndSlovimFunctionCodeGenerator >> setVariable: variable forNode: node [
	functionVariables at: node put: variable
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> setupBuilders [
	"Create the main slvm builder."	
	| initialDebugPosition |
	slvmBuilder := MbndSLVMBuilder on: ssaFunction.
	ssaFunctionEntryBlock := slvmBuilder newBasicBlockHere: #entry.
	entryPointLocalInitializations := OrderedCollection new.
	exceptionHandlingCodeGenerator := self createExceptionHandlingCodeGenerator.
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

{ #category : #accessing }
MbndSlovimFunctionCodeGenerator >> ssaFunction [
	^ ssaFunction
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

	targetType isNativeBlockClosureType ifTrue: [
		self flag: 'TODO: Implement this case properly.'.
		self halt.
		^ SLVMConstant nullPointer: (self translateType: targetType) 
	].

	targetType isVoidType ifTrue: [ ^ nil ].

	self error: 'TODO: Implement this case.'
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> vectorThreeWayComparisonResultMerge: elementWiseResult [
	| elementWiseResultType factors |
	elementWiseResultType := elementWiseResult type.
	self assert: elementWiseResultType elements < 16.
	factors := SLVMConstant vector: elementWiseResultType elements: ((0 to: elementWiseResultType elements - 1) collect: [ :i |
		SLVMConstant int: 1<<(30 - (i*2))
	]).
	
	^ self slvmBuilder vectorDot: elementWiseResult with: factors
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitArrayConstructionNode: node [
	| elements tempVar arrayType slvmArrayType |
	elements := self visitNodesAndCollect: node elements.
	self assert: node type isTemporaryReferenceType.
	arrayType := node type baseType.
	slvmArrayType := self translateType: arrayType.
	tempVar := self allocateTemporaryStorageFor: slvmArrayType withStorageCreationNode: node storageCreationNode.
	elements doWithIndex: [ :element :index |
		| destPointer sourceElementType |
		sourceElementType := (node elements at: index) type.
		destPointer := slvmBuilder getReference: tempVar element: (slvmBuilder constInt: index - 1).
		self generateVariable: destPointer withValueType: arrayType elementType initializationWithValue: element
			initialValueKind: (sourceElementType isTemporaryReferenceType ifTrue: [#move] ifFalse: [#copy])
	].

	arrayType hasTrivialFinalization ifFalse: [ 
		self addLocalVariable: tempVar withValueType: arrayType cleanUpActionForNode: node
	].

	^ tempVar
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitArrayElementReferenceNode: node [
	| pointer index arrayType |
	pointer := self visitNode: node container.
	index := self visitNode: node index.
	self assert: index type isIntegerType.
	"Convert one based indices into zero based indices."
	node isOneBasedIndex ifTrue: [ 
		index := slvmBuilder sub: index with: (SLVMConstant type: index type value: 1)
	].

	arrayType := node container type withoutReferences withoutTopDecorations.
	(arrayType isArrayType and: [ arrayType elements isNotNil and: [ arrayType elements > 0 ] ]) ifTrue: [ 
		self generateIndex: index sizeBoundsCheck: [ (SLVMConstant type: index type value: arrayType elements) ]
	].

	^ slvmBuilder getReference: pointer element: index
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitArraySliceDecorationChangeCastNode: node [
	| sourceSlice targetSlice |
	sourceSlice := self visitNode: node expression.
	targetSlice := SLVMConstant undefined: (self translateType: node type).
	targetSlice := slvmBuilder insertValue: targetSlice value: (slvmBuilder extractValue: sourceSlice indices: {0}) indices: {0}.
	targetSlice := slvmBuilder insertValue: targetSlice value: (slvmBuilder extractValue: sourceSlice indices: {1}) indices: {1}.
	^ targetSlice
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitArraySliceElementReferenceNode: node [
	| arraySlice index elements |
	arraySlice := self visitNode: node container.
	index := self visitNode: node index.
	self assert: index type isIntegerType.
	"Convert one based indices into zero based indices."
	node isOneBasedIndex ifTrue: [ 
		index := slvmBuilder sub: index with: (SLVMConstant type: index type value: 1)
	].

	self generateIndex: index sizeBoundsCheck: [ slvmBuilder extractValue: arraySlice indices: { 1 } ].
	
	elements := slvmBuilder extractValue: arraySlice indices: { 0 }.
	^ slvmBuilder getPointer: elements element: {index}
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
	| matchedValue literalGroupStream temporaryResult valueType result |
	matchedValue := self visitNode: node matchedExpression.
	literalGroupStream := node cases readStream.
	temporaryResult := nil.
	node type isTemporaryReferenceType ifTrue: [
		valueType := node type baseType.
		temporaryResult := self allocateTemporaryStorageFor: (self translateType: valueType) withStorageCreationNode: node storageCreationNode.
	].

	result := self generateCasesOfNode: node matchedValue: matchedValue temporaryResult: temporaryResult caseStream: literalGroupStream.
	
	(slvmBuilder isLastTerminator not and: [temporaryResult isNotNil]) ifTrue: [ 
		self assert: result == temporaryResult.
		valueType hasTrivialFinalization ifFalse: [
			self addLocalVariable: temporaryResult withValueType: valueType cleanUpActionForNode: node
		].
	].

	^ result
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
MbndSlovimFunctionCodeGenerator >> visitCopyIntoTemporaryVariableNode: node [
	| value valueType tempVar |
	value := self visitNode: node value.
	self assert: node type isTemporaryReferenceType. 
	valueType := node type baseType.
	tempVar := self allocateTemporaryStorageFor: (self translateType: valueType) withStorageCreationNode: node storageCreationNode.
	
	value type isPointerType ifFalse: [
		slvmBuilder store: value in: tempVar.
	] ifTrue: [
		tempVar ~~ value ifTrue: [ 
			self generateVariable: tempVar withValueType: valueType initializationWithValue: value initialValueKind: #copy
		].
	].

	valueType hasTrivialFinalization ifFalse: [ 
		self addLocalVariable: tempVar withValueType: valueType cleanUpActionForNode: node
	].
	
	^ tempVar
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDecorationChangeTypeCastNode: node [
	| source |
	source := self visitNode: node expression.
	^ source
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitDestructuringAssignmentNode: node [
	| matchedValue isPatternMatched |
	matchedValue := self visitNode: node value.
	isPatternMatched := self generatePattern: node pattern matchingWithValue: matchedValue.
	self generatePatternNotMatchedTrap: isPatternMatched.
	^ matchedValue
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
	^ exceptionHandlingCodeGenerator generateExceptionScopeNode: node
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
		fieldValue := slvmBuilder load: (slvmBuilder getReference: aggregate element: (slvmBuilder constInt: field slotIndex))
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
	"Special case where we cannot use a phi node."
	node type isTemporaryReferenceType ifTrue: [ ^ self visitIfTemporaryCreatingConditionNode: node ].
	
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
MbndSlovimFunctionCodeGenerator >> visitIfTemporaryCreatingConditionNode: node [
	| condition mergeBlock thenBlock elseBlock valueType tempVar |
	condition := self visitBooleanNode: node condition.

	thenBlock := slvmBuilder newBasicBlock: #ifThen.
	elseBlock := slvmBuilder newBasicBlock: #ifElse.
	mergeBlock := slvmBuilder newBasicBlock: #ifMerge.
		
	slvmBuilder currentBlock mergeBlock: mergeBlock.
	slvmBuilder branch: condition ifTrue: thenBlock ifFalse: elseBlock.
	
	self assert: node type isTemporaryReferenceType.
	valueType := node type baseType.
	tempVar := self allocateTemporaryStorageFor: (self translateType: valueType) withStorageCreationNode: node storageCreationNode.
	
	slvmBuilder currentBlock: thenBlock.
	node trueValue ifNil: [
		self generateVariable: tempVar initializationWithValueType: valueType
	] ifNotNil: [
		| trueResult |
		trueResult := self visitNode: node trueValue.
		slvmBuilder isLastTerminator ifFalse: [ 
			self generateVariable: tempVar withValueType: valueType initializationWithValue: trueResult initialValueKind: (node trueValue type isTemporaryReferenceType
				ifTrue: [#move] ifFalse: [#copy]).
			slvmBuilder jump: mergeBlock.
		]
	].

	slvmBuilder isLastTerminator ifFalse: [ 
		slvmBuilder jump: mergeBlock.
	].

	slvmBuilder currentBlock: elseBlock.
	node falseValue ifNil: [
		self generateVariable: tempVar initializationWithValueType: valueType
	] ifNotNil: [
		| falseResult |
		falseResult := self visitNode: node falseValue.
		slvmBuilder isLastTerminator ifFalse: [ 
			self generateVariable: tempVar withValueType: valueType initializationWithValue: falseResult initialValueKind: (node falseValue type isTemporaryReferenceType
				ifTrue: [#move] ifFalse: [#copy]).
		]
	].

	slvmBuilder isLastTerminator ifFalse: [ 
		slvmBuilder jump: mergeBlock.
	].

	"Enter the merge block."
	slvmBuilder currentBlock: mergeBlock.

	valueType hasTrivialFinalization ifFalse: [
		self addLocalVariable: tempVar withValueType: valueType cleanUpActionForNode: node
	].

	^ tempVar
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
MbndSlovimFunctionCodeGenerator >> visitMatchingMatchedValueNode: node [
	^ functionVariables at: node
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
MbndSlovimFunctionCodeGenerator >> visitMatrixTransposeNode: node [
	| matrix |
	matrix := self visitNode: node matrix.
	^ slvmBuilder matrixTranspose: matrix
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
MbndSlovimFunctionCodeGenerator >> visitNumberToBooleanCastNode: node [
	| number zeroConstant numberType |
	number := self visitNode: node expression.
	zeroConstant := number type defaultConstant.
	numberType := number type.
	(numberType isFloatType or: [ (numberType isVectorType or: [ numberType isMatrixType ]) and: [ numberType elementType isFloatType ] ]) ifTrue: [
		^ slvmBuilder ufne: number with: zeroConstant
	] ifFalse: [ 
		^ slvmBuilder ine: number with: zeroConstant
	].

	self halt
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
MbndSlovimFunctionCodeGenerator >> visitPointerToArraySliceNode: node [
	| pointer firstIndex lastIndex size result sliceType sizeType |
	pointer := self visitNode: node pointer.
	firstIndex := self visitNode: node firstIndex.
	lastIndex := self visitNode: node lastIndex.
	
	node isOneBasedIndex ifTrue: [ 
		firstIndex := slvmBuilder sub: firstIndex with: (SLVMConstant type: firstIndex type value: 1).
		lastIndex := slvmBuilder sub: lastIndex with: (SLVMConstant type: lastIndex type value: 1).
	].

	sliceType := self translateType: node type.
	sizeType := sliceType types second.
	pointer := slvmBuilder getPointer: pointer element: { firstIndex }.
	size := slvmBuilder sub: (slvmBuilder intCast: lastIndex target: sizeType) with: (slvmBuilder intCast: firstIndex target: sizeType).
	result := SLVMConstant undefined: sliceType.
	result := slvmBuilder insertValue: result value: pointer indices: { 0 }.
	result := slvmBuilder insertValue: result value: size indices: { 1 }.
	^ result
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
			self generateVariable: tempVar withValueType: node type initializationWithValue: reference initialValueKind: #copy.
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

	exceptionHandlingCodeGenerator emitCleansUpBySupressing: suppresedCleanUpTokens forReturningWith: [ 
		slvmBuilder isLastTerminator ifTrue: [ ^ nil ].
		self generateAutomaticEpilogueCode.
		nonLocalReturnTargetRef ifNotNil: [ :targetContext |
			node expectedReturnType isVoidType ifFalse: [ 
				node expectedReturnType isMemoryReturnedType ifFalse: [
					self compilationTarget usesExceptionsForNonLocalReturns ifTrue: [ 
						self assert: nonLocalReturnResultRef isNotNil.
						slvmBuilder store: (self sanitizeStoreValue: result inPointer: nonLocalReturnResultRef) in: nonLocalReturnResultRef
					] ifFalse: [
						^ slvmBuilder return: result fromContext: nonLocalReturnTargetRef
					].
				].
			].
		
			self compilationEnvironment hasExceptions ifFalse: [
				self error: 'Cannot generate non-local return when exceptions are disabled' at: node.
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

	texcoord := self expandTexcoord: texcoord toCanonicalCPUTexcoordFor: node texture type.
	self assert: texcoord type elements = 4.

	dtdx := self expandTexcoord: dtdx toCanonicalCPUTexcoordFor: node texture type.
	self assert: dtdx type elements = 4.

	dtdy := self expandTexcoord: dtdy toCanonicalCPUTexcoordFor: node texture type.
	self assert: dtdy type elements = 4.
	
	^ slvmBuilder call: codeModuleGenerator sampleTextureExplicitDerivativesFunction arguments: { sampler . texture . texcoord . dtdx . dtdy}
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


	texcoord := self expandTexcoord: texcoord toCanonicalCPUTexcoordFor: node texture type.
	self assert: texcoord type elements = 4.
	^ slvmBuilder call: codeModuleGenerator sampleTextureExplicitLodFunction arguments: { sampler . texture . texcoord . lod}
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

	texcoord := self expandTexcoord: texcoord toCanonicalCPUTexcoordFor: node texture type.
	self assert: texcoord type elements = 4.
	^ slvmBuilder call: codeModuleGenerator sampleTextureImplicitLodFunction arguments: { sampler . texture . texcoord }
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
		fieldPointer := slvmBuilder getReference: aggregate element: (slvmBuilder constInt: field slotIndex).
		
		field bits ifNil: [
			slvmBuilder store: (self sanitizeStoreValue: newValue inPointer: fieldPointer)
				in: fieldPointer
		] ifNotNil: [
			| originalValue newBitValue sanitizedValue valueType |
			sanitizedValue := self sanitizeStoreValue: newValue inPointer: fieldPointer.
			valueType := sanitizedValue type.
			sanitizedValue := slvmBuilder shiftLeft: sanitizedValue with: (slvmBuilder const: field bitOffset type: valueType).
			sanitizedValue := slvmBuilder bitAnd: sanitizedValue with: (slvmBuilder const: field bitMask type: valueType).

			originalValue := slvmBuilder load: fieldPointer.
			newBitValue := slvmBuilder bitAnd: originalValue with: (slvmBuilder const: field bitMask bitInvert type: valueType).
			newBitValue := slvmBuilder bitOr: newBitValue with: sanitizedValue.
			slvmBuilder store: newBitValue in: fieldPointer
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
		self flag: 'TODO: Implement down-casting in a proper way'.
		 ^ slvmBuilder bitCast: sourceValue target: targetSSAType
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
MbndSlovimFunctionCodeGenerator >> visitTupleElementReferenceNode: node [
	| tuple index |
	tuple := self visitNode: node container.
	tuple type isPointerType ifTrue: [
		^ slvmBuilder getReference: tuple element: (slvmBuilder constInt: node index) 
	].

	self assert: tuple type isStructureType.
	^ slvmBuilder extractValue: tuple indices: { node index }
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitTupleNode: node [
	| elements resultType result tupleType |
	elements := node elements collect: [ :each | self visitNode: each ].
	
	resultType := self translateType: node type.
	resultType isPointerType ifTrue: [
		tupleType := node type baseType.
		self assert: tupleType isTupleType.
		result := self allocateTemporaryStorageFor: (self translateType: tupleType) withStorageCreationNode: node storageCreationNode.
		0 to: tupleType elements size - 1 do: [ :i |
			| elementPointer elementValue elementType |
			elementPointer := slvmBuilder getReference: result element: (slvmBuilder constInt: i).
			elementValue := elements at: i + 1.
			elementType := (node elements at: i + 1) type.
			self generateVariable: elementPointer withValueType: elementType withoutReferences withoutTopDecorations 
		initializationWithValue: elementValue initialValueKind: (elementType isTemporaryReferenceType
			ifTrue: [ #move ]
			ifFalse: [ #copy ]).
		].

		tupleType hasTrivialFinalization ifFalse: [
			self addLocalVariable: result withValueType: tupleType cleanUpActionForNode: node
		].
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
MbndSlovimFunctionCodeGenerator >> visitTupleSplicingNode: node [
	| tuple |
	node elementIndex = 1 ifTrue: [
		tuple := self visitNode: node tupleExpression.
		functionVariables at: node put: tuple.
	] ifFalse: [ 
		tuple := functionVariables at: node tupleExpression.
	].

	tuple type isPointerType ifFalse: [ 
		^ slvmBuilder extractValue: tuple indices: {node elementIndex - 1}
	].

	self halt
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
MbndSlovimFunctionCodeGenerator >> visitVariantBoxCreateNode: node [
	| boxedValue variantStorage componentPointer variantType |
	boxedValue := self visitNode: node boxedValue.
	variantType := node variantType.
	variantStorage := self allocateTemporaryStorageFor: (self translateType: node variantType) withStorageCreationNode: node storageCreationNode.

	"Set the type selector."
	slvmBuilder store: (slvmBuilder constUChar: node typeSelector)
		in: (slvmBuilder getReference: variantStorage element: (slvmBuilder constInt: 0)).
		
	"Get the component pointer"
	componentPointer := slvmBuilder getPointer: variantStorage element: {
		"Variant itself." slvmBuilder constInt: 0.
		"Union." slvmBuilder constInt: 1.
		"Component." slvmBuilder constInt: node typeSelector.
	}.
	self generateVariable: componentPointer withValueType: node boxedValue type withoutReferences withoutTopDecorations 
		initializationWithValue: boxedValue initialValueKind: (node boxedValue type isTemporaryReferenceType
			ifTrue: [ #move ]
			ifFalse: [ #copy ]).
	variantType hasTrivialFinalization ifFalse: [
		self addLocalVariable: variantStorage withValueType: variantType cleanUpActionForNode: node
	].

	^ variantStorage
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVariantTypeSelectorExtractionNode: node [
	| variant |
	variant := self visitNode: node variant.
	variant type isPointerType ifTrue: [ 
		self assert: variant type baseType isStructureType.
		^ slvmBuilder load: (slvmBuilder getReference: variant element: (slvmBuilder constInt: 0))
	] ifFalse: [
		self assert: variant type isStructureType.
		^ slvmBuilder extractValue: variant indices: {0}
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVariantUnboxingAssignmentReferenceNode: node [
	| variant variantType typeSelectorPointer elementType|
	variantType := node variant type withoutReferences withoutTopDecorations.
	self assert: variantType isVariantUnionType.
	
	variant := self visitNode: node variant.
	self assert: variant type isPointerType.

	typeSelectorPointer := slvmBuilder getReference: variant element: (slvmBuilder constInt: 0).
	elementType := variantType typeWithSelector: node typeSelector.

	(elementType hasTrivialBasicInitialization and: [elementType hasTrivialInitialization and: [ variantType hasTrivialFinalization ]]) ifTrue: [ 
		"Set the selector and return reference."
		slvmBuilder store: (slvmBuilder constUChar: node typeSelector) in: variant.
	] ifFalse: [ 
		| typeSelector isMatchingSelector nonMatchingSelectorBlock variantInitializedBlock |
		"Non trivial case. Destroy and initialize the variant."
		typeSelector := slvmBuilder load: typeSelectorPointer.
		isMatchingSelector := slvmBuilder ieq: typeSelector with: (slvmBuilder constInt: 0).
		nonMatchingSelectorBlock := slvmBuilder newBasicBlock: #variantNotMatchingType.
		variantInitializedBlock := slvmBuilder newBasicBlock: #variantInitialized.
		slvmBuilder currentBlock mergeBlock: variantInitializedBlock.
		slvmBuilder branch: isMatchingSelector ifTrue: variantInitializedBlock ifFalse: nonMatchingSelectorBlock.

		slvmBuilder currentBlock: nonMatchingSelectorBlock.

		"Finalize the variant"		
		variantType hasTrivialFinalization ifFalse: [ 
			self halt.
		].

		elementType hasTrivialBasicInitialization ifFalse: [
			self halt.
		].
		elementType hasTrivialInitialization ifFalse: [ 
			self halt.
		].
	
		"Set the new selector."
		slvmBuilder store: (slvmBuilder constUChar: node typeSelector) in: variant.
		
		slvmBuilder jump: variantInitializedBlock.
		slvmBuilder currentBlock: variantInitializedBlock.

	].

	^ slvmBuilder getPointer: variant element: {
		"Variant itself" slvmBuilder constInt: 0.
		"Union" slvmBuilder constInt: 1.
		"Selected element" slvmBuilder constInt: node typeSelector
	}

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVariantUnboxingNode: node [
	| variant typeSelector componentPointer |
	variant := self visitNode: node variant.
	
	node unchecked ifFalse: [ 
		typeSelector := variant type isPointerType ifTrue: [ 
			slvmBuilder load: (slvmBuilder getReference: variant element: (slvmBuilder constInt: 0))
		] ifFalse: [
			slvmBuilder extractValue: variant indices: { 0 } 
		].
	
		self emitVariantTypeSelectorCheck: typeSelector withExpectedTypeSelector: (slvmBuilder constUChar: node typeSelector)
	].

	componentPointer := slvmBuilder getPointer: ( 
		variant type isPointerType ifTrue: [
			variant
		] ifFalse: [ 
			| temporary |
			temporary := slvmBuilder allocaBuilder alloca: variant type.
			slvmBuilder store: variant in: temporary.
			temporary
		])  element: {
		"Variant itself" slvmBuilder constInt: 0.
		"Union" slvmBuilder constInt: 1.
		"Type component" slvmBuilder constInt: node typeSelector.
	}.

	^ variant type isPointerType ifTrue: [
		componentPointer 
	] ifFalse: [
		slvmBuilder load: componentPointer
	]
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
MbndSlovimFunctionCodeGenerator >> vistVAListEndExpressionNode: node [
	| valist |
	valist := self visitNode: node valist.
	^ slvmBuilder valistEnd: valist
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> vistVAListStartExpressionNode: node [
	| valist |
	valist := self visitNode: node valist.
	^ slvmBuilder valistStart: valist
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

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> wrapValue: value withType: valueType intoDynamicObjectWithType: dynamicObjectType [
	| wrappedValue |
	self assert: dynamicObjectType isGarbageCollectedType.
	
	wrappedValue := nil.
	self flag: 'FIXME: Use double dispatch here'.
	valueType isGarbageCollectedType ifTrue: [ 
		self flag: 'TODO: Perform a type check here.'.
		wrappedValue := value.
	].

	(wrappedValue isNil and: [valueType isVoidType]) ifTrue: [
		wrappedValue := slvmBuilder addDynamicLiteral: nil
	].

	(wrappedValue isNil and: [valueType isPrimitiveBooleanType]) ifTrue: [ 
		wrappedValue := slvmBuilder boolToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	(wrappedValue isNil and: [valueType isPrimitiveCharacterCodeType]) ifTrue: [ 
		wrappedValue := slvmBuilder charToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	(wrappedValue isNil and: [valueType isPrimitiveIntegerType]) ifTrue: [ 
		wrappedValue := slvmBuilder intToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	(wrappedValue isNil and: [valueType isPrimitiveFloatType]) ifTrue: [ 
		wrappedValue := slvmBuilder floatToDynamicObjectCast: value target: (self translateType: dynamicObjectType)
	].

	(wrappedValue isNil and: [valueType isPointerLikeType]) ifTrue: [
		wrappedValue := slvmBuilder addDynamicLiteral: nil
	].

	(wrappedValue isNil and: [valueType isMetaType]) ifTrue: [
		wrappedValue := value
	].

	wrappedValue ifNil: [ 
		self error: 'TODO: Implement this case.'
	].

	^ slvmBuilder bitCast: wrappedValue target: (self translateType: dynamicObjectType)
]
