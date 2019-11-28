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
		'currentContinueBlock'
	],
	#classVars : [
		'AdditionalIntrinsicsDictionary',
		'EvaluationOnlyIntrinsics'
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
	)
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> buildSSAFunction: aSSAFunction definitionWithConcreteMethod: aConcreteMethod [
	| entryBlock bodyBlock result |
	ssaFunction := aSSAFunction.
	concreteMethod := aConcreteMethod.
	functionVariables := Dictionary new.
	self assert: concreteMethod analyzedBody isNotNil.
	
	"Define the argument values."
	self defineArgumentValues.

	"Create the main slvm builder."	
	slvmBuilder := SLVMBuilder on: ssaFunction.
	entryBlock := slvmBuilder newBasicBlockHere: #entry.

	"Create the alloca builder."
	slvmBuilder allocaBuilder: ((SLVMBuilder on: ssaFunction)
		currentBlock: entryBlock).

	"Create the body block."	
	bodyBlock := slvmBuilder newBasicBlockHere: #body.
	
	"Initialize the argument variables."
	self initializeArgumentVariables.
	
	"Generate the body code."
	result := self visitNode: concreteMethod analyzedBody.
	slvmBuilder currentBlock isLastTerminator ifTrue: [
		self assert: concreteMethod analyzedBody type isReturnType.
	] ifFalse: [ 
		self assert: concreteMethod analyzedBody type isReturnType not.
		
		concreteMethod returnType isVoidType ifTrue: [
			slvmBuilder returnVoid.
		] ifFalse: [
			slvmBuilder return: result
		]
	].

	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: bodyBlock.
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> createLocalVariableDebugInformation: localVariable [
	^ (SLVMDebugVariable scope: nil name: localVariable name asPrettySymbolName)
		type: (self translateType: localVariable type);
		yourself
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> defineArgumentValues [
	| argumentValue |
	self assert: concreteMethod arguments size = ssaFunction arguments size.
	concreteMethod arguments doWithIndex: [ :argVariable :argIndex |
		argumentValue := ssaFunction arguments at: argIndex.
		argVariable name isMbndAnonymousSymbol ifFalse: [
			argumentValue name: argVariable name
		].
	
		functionVariables at: argVariable put: argumentValue
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateExpandedMessageSendNode: node withIntrinsicName: intrinsicName [
	AdditionalIntrinsicsDictionary at: intrinsicName ifPresent: [ :selector |
		^ self perform: selector with: node
	].
	(EvaluationOnlyIntrinsics includes: intrinsicName) ifTrue: [
		^ self generateExpandedMessageSendNode: node withStaticMethodBoundTo: (self translateProgramEntity: node method) ssaValue
	].
	^ self generateExpandedMessageSendNode: node withStaticMethodBoundTo: (codeModuleGenerator intrinsicConstantBuiltInFunction: intrinsicName withType: node method type)
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> generateExpandedMessageSendNode: node withStaticMethodBoundTo: methodSSAFunction [
	| receiver receiverType arguments allArguments calledMethodSSAFunction vtableLayout vtableSlot vtableEntrySlot result expectedResultType hasDynamicMessageLookup selectorValue |
	receiver := node receiver ifNotNil: [self visitNode: node receiver].
	selectorValue := self visitNode: node selector.
	arguments := self visitNodesAndCollect: node arguments.
	allArguments := arguments.

	hasDynamicMessageLookup := node receiver
		ifNil: [ false ]
		ifNotNil: [:receiverNode | hasDynamicMessageLookup := receiverNode type hasDynamicMessageLookup].
	receiver ifNotNil: [
		allArguments := { receiver } , arguments
	].

	calledMethodSSAFunction := methodSSAFunction.
	node method hasVirtualTableEntry ifTrue: [
		hasDynamicMessageLookup := false.
		receiverType := node receiver type withoutReferences.
		vtableLayout := receiverType slotLayout mainVirtualTable.
	
		vtableSlot := slvmBuilder load: (slvmBuilder getReference: receiver
								element: (slvmBuilder constInt: vtableLayout slotIndex)).
		vtableEntrySlot := slvmBuilder load: (slvmBuilder getPointer: vtableSlot
								element: {slvmBuilder constInt: (vtableLayout getSlotIndexFor: node method virtualTableSelector)}).
		calledMethodSSAFunction := slvmBuilder bitCast: vtableEntrySlot target: methodSSAFunction type.
	].
	
	(node method hasPragmaNamed: #staticBinding) ifTrue: [ hasDynamicMessageLookup := false ].
	
	expectedResultType := self translateType: node type.
	hasDynamicMessageLookup ifTrue:[
		selectorValue isSymbol ifTrue: [ selectorValue := slvmBuilder addDynamicLiteral: selectorValue ].
		self assert: selectorValue type isDynamicObjectPointerType.
		result := slvmBuilder send: selectorValue returnType: expectedResultType receiver: receiver arguments: arguments
	] ifFalse: [
		result := slvmBuilder call: calledMethodSSAFunction arguments: allArguments.
	].

	"We may need to adjust the result type in the case of dependent types."
	result type ~~ expectedResultType ifTrue: [ 
		self assert: (result type isPointerType and: [ expectedResultType isPointerType ]).
		result := slvmBuilder bitCast: result target: expectedResultType
	].

	^ result
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
			debugInformation := self createLocalVariableDebugInformation: argument.
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
	(slvmBuilder store: value in: reference)
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
MbndSlovimFunctionCodeGenerator >> visitCleanUpScopeNode: node [
	| result |
	result := self visitNode: node expression.
	slvmBuilder isLastTerminator ifFalse: [ 
		node cleanUpActions do: [ :cleanUpAction | self visitNode: cleanUpAction ]
	].
	^ result
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
MbndSlovimFunctionCodeGenerator >> visitExpandedMessageSendNode: node [
	| receiver arguments methodProgramEntity |
	node method ifNotNil: [
		methodProgramEntity := self translateProgramEntity: node method.
		^ methodProgramEntity generateExpandedMessageSendNode: node with: self
	].

	receiver := node receiver ifNotNil: [ :expr | self visitNode: expr ].
	arguments := self visitNodesAndCollect: node arguments.
	self halt
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
	| functionValue argumentValues |
	functionValue := self visitNode: node function.
	argumentValues := self visitNodesAndCollect: node arguments.
	^ slvmBuilder call: functionValue arguments: argumentValues
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

	^ fieldValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIfConditionNode: node [
	| condition mergeBlock thenBlock elseBlock trueResult falseResult hasTrueResult hasFalseResult resultType branchBlock |
	condition := self visitNode: node condition.
	thenBlock := node trueValue ifNotNil: [slvmBuilder newBasicBlock: #ifThen].
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
	^ self visitCleanUpScopeNode: node
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
	| initialValue valueType ssaValue |
	self assert: (functionVariables includesKey: node binding) not.
	
	initialValue := node initialValue ifNotNil: [ :iv | self visitNode: iv ].
	valueType := self translateType: node valueType.
	
	node isMutable ifTrue: [
		self assert: node type isReferenceType.
		(node isAccessedByReference and: [node initialValue type isReferenceType]) ifTrue: [
			self assert: initialValue isNotNil.
			ssaValue := initialValue.

			self isEmittingDebugInformation ifTrue: [ 
				node name isMbndGenerateSymbolRemovedFromDebug ifFalse: [
					(slvmBuilder debugSetVariable: (self createLocalVariableDebugInformation: node binding) value: ssaValue)
				]
			].
		] ifFalse: [ 
			ssaValue := slvmBuilder allocaBuilder alloca: valueType.

			initialValue ifNotNil: [
				slvmBuilder store: initialValue in: ssaValue
			].

			self isEmittingDebugInformation ifTrue: [ 
				node name isMbndGenerateSymbolRemovedFromDebug ifFalse: [
					(slvmBuilder debugDeclareVariable: ssaValue)
						debugInformation: (self createLocalVariableDebugInformation: node binding)
				]
			].
		].
	] ifFalse: [
		self assert: node initialValue isNotNil.
		ssaValue := initialValue.

		self isEmittingDebugInformation ifTrue: [ 
			node name isMbndGenerateSymbolRemovedFromDebug ifFalse: [
				(slvmBuilder debugSetVariable: (self createLocalVariableDebugInformation: node binding) value: ssaValue)
			]
		].

	].

	functionVariables at: node binding put: ssaValue.
	^ ssaValue
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
	| debugPosition |
	self isEmittingDebugInformation ifTrue: [ 

		"Keep track of the debug position"
		debugPosition := codeModuleGenerator convertDebugPosition: node asActualSourcePosition.
		slvmBuilder pushDebugSourcePosition: debugPosition.
		slvmBuilder allocaBuilder pushDebugSourcePosition: debugPosition.
		
		^ [
			super visitNode: node.
		] ensure: [
			slvmBuilder popDebugSourcePosition.
			slvmBuilder allocaBuilder popDebugSourcePosition.
		]
	].

	^ super visitNode: node
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
	| reference |
	reference := self visitNode: node reference.
	^ (slvmBuilder load: reference)
		volatile: node reference type isVolatileType;
		yourself
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitReturnStatementNode: node [
	| result |
	result := node expression ifNotNil: [ :expr | self visitNode: expr ].
	^ concreteMethod returnType isVoidType ifTrue: [
		slvmBuilder returnVoid
	] ifFalse: [
		self assert: result isNotNil.
		slvmBuilder return: result
	]
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
			slvmBuilder store: newValue in: fieldPointer
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
MbndSlovimFunctionCodeGenerator >> visitTruncateCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder truncate: source target: targetType
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVariableReferenceNode: node [
	| binding |
	binding := node binding.
	functionVariables at: binding ifPresent: [ :ssaValue | ^ ssaValue ].
	^ (codeModuleGenerator translateProgramEntity: binding) ssaValue
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
