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
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

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
MbndSlovimFunctionCodeGenerator >> generateExpandedMessageSendNode: node withStaticMethodBoundTo: methodSSAFunction [
	| receiver arguments allArguments |
	receiver := node receiver ifNotNil: [self visitNode: node receiver].
	arguments := self visitNodesAndCollect: node arguments.
	allArguments := arguments.
	receiver ifNotNil: [
		allArguments := { receiver } , arguments
	].
	
	^ slvmBuilder call: methodSSAFunction arguments: allArguments
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
MbndSlovimFunctionCodeGenerator >> visitAssignmentNode: node [
	| value reference |
	value := self visitNode: node value.
	reference := self visitNode: node reference.
	^ (slvmBuilder store: value in: reference)
		volatile: node reference type isVolatileType;
		yourself
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
		self halt
	].

	^ fieldValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitIfConditionNode: node [
	| condition mergeBlock thenBlock elseBlock trueResult falseResult hasTrueResult hasFalseResult resultType branchBlock |
	condition := self visitNode: node condition.
	mergeBlock := slvmBuilder newBasicBlock: #ifMerge.
	thenBlock := node trueValue
		ifNil: [ mergeBlock ]
		ifNotNil: [slvmBuilder newBasicBlock: #ifThen].
	elseBlock := node falseValue
		ifNil: [ mergeBlock ]
		ifNotNil: [slvmBuilder newBasicBlock: #ifElse].
		
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
		ssaValue := slvmBuilder allocaBuilder alloca: valueType.
		initialValue ifNotNil: [
			slvmBuilder store: initialValue in: ssaValue
		].
	] ifFalse: [
		self assert: node initialValue isNotNil.
		ssaValue := initialValue.
	].

	functionVariables at: node binding put: ssaValue.
	^ ssaValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMethodReferenceNode: node [
	^ (codeModuleGenerator translateProgramEntity: node binding) ssaValue
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

	node type isVoidType ifTrue: [ 
		result := nil.
	] ifFalse: [ 
		result ifNil: [ self halt ].
	].
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSignExtensionCastNode: node [
	| source targetType |
	source := self visitNode: node expression.
	targetType := self translateType: node type.
	^ slvmBuilder signExtend: source target: targetType
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
