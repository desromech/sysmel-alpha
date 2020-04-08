Class {
	#name : #MbndAstEvaluator,
	#superclass : #MbndAstVisitor,
	#instVars : [
		'module',
		'scope',
		'currentBreakContext',
		'currentContinueContext'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Evaluation'
}

{ #category : #'as yet unclassified' }
MbndAstEvaluator >> evaluateFunctionContent: ast [
	| returnContext |
	returnContext := self scope returnContextScope.
	
	[ 
		^ self visitNode: ast
	] on: MbndEvaluationReturn do: [ :e |
		e targetReturnContext == returnContext
			ifTrue: [ ^ e returnValue ]
			ifFalse: [ ^ e pass ]
	]
	
]

{ #category : #accessing }
MbndAstEvaluator >> module [
	^ module
]

{ #category : #accessing }
MbndAstEvaluator >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndAstEvaluator >> scope [
	^ scope
]

{ #category : #accessing }
MbndAstEvaluator >> scope: anObject [
	scope := anObject
]

{ #category : #visiting }
MbndAstEvaluator >> visitArrayConstructionNode: node [
	| result |
	result := node type defaultValueAt: node.
	
	node elements doWithIndex: [ :el :index |
		result slots at: index put: (self visitNode: el) unwrapMbndValue
	].
	^ result
]

{ #category : #visiting }
MbndAstEvaluator >> visitAssignmentNode: node [
	| value reference |
	value := self visitNode: node value.
	reference := self visitNode: node reference.
	
	reference value value: value copyForValueAssignment.
	^ reference
]

{ #category : #visiting }
MbndAstEvaluator >> visitBitCastNode: node [
	| originalValue |
	originalValue := self visitNode: node expression.
	^ originalValue asMoebiusValueWithType: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitBlockClosureNode: node [
	| capturedValues |
	capturedValues := node blockClosureProgramEntity extractCapturedValuesFromEvaluationScope: scope.
	^ MbndBlockClosureInstance new
		closureProgramEntity: node blockClosureProgramEntity;
		capturedValues: capturedValues;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitClassDeclarationNode: node [
	^ self visitTypeDeclarationNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitClassDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitConcretizeUndefinedValueCastNode: node [
	self halt
]

{ #category : #visiting }
MbndAstEvaluator >> visitConvertFromCompilerObjectCastNode: node [
	| result |
	result := (self visitNode: node expression) unwrapMbndValue.
	result := (node targetType legalizeLiteralValue: result).
	^ MbndValue value: result type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitConvertToASTNodeCastNode: node [
	| result resultNode |
	result := self visitNode: node expression.
	resultNode := result unwrapMbndValue.
	resultNode isMbndAstNode ifFalse: [ 
		resultNode := resultNode	asMoebiusLiteralValueNodeWithTarget: module compilationTarget.
	].

	^ MbndValue value: resultNode type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitConvertToCompilerObjectCastNode: node [
	| result |
	result := self visitNode: node expression.
	^ result copy
		type: node type;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitDoWhileLoopNode: node [
	| loopContext hasReceivedBreak |
	loopContext := Object new.
	
	hasReceivedBreak := false.
	[
		[
			self withBreakAndContinueContext: loopContext do: [
				node action ifNotNil: [ :action | self visitNode: action ]
			]
		] on: MbndBlockExitAction do: [ :e |
			e blockContext == loopContext ifFalse: [
				^ e pass.
			].
		
			hasReceivedBreak := e isBreakAction.
		].
	
		hasReceivedBreak ifFalse: [
			node continueAction ifNotNil: [ :action | self visitNode: action ]
		].
	] doWhileTrue: [
		hasReceivedBreak not and: [
			node condition
				ifNil: [ true ]
				ifNotNil: [(self visitNode: node condition) unwrapMbndValue]]
	].

	^ node type defaultValue
]

{ #category : #visiting }
MbndAstEvaluator >> visitEnumDeclarationNode: node [
	^ self visitTypeDeclarationNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitEnumDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitExpandedHostMessageSendNode: node [
	| receiver selector arguments result |
	receiver := (self visitNode: node receiver) unwrapMbndValue.
	selector := (self visitNode: node selector) unwrapMbndValue.
	arguments := node arguments collect: [ :arg| (self visitNode: arg) unwrapMbndValue ].
	result := receiver perform: selector withArguments: arguments.
	^ MbndValue value: result type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitExpandedMessageSendNode: node [
	| receiver arguments |
	self assert: node type isNotNil.
	self assert: node method isNotNil.
	receiver := node receiver ifNotNil: [ self visitNode: node receiver ].
	arguments := self visitNodesAndCollect: node arguments.
	^ node method evaluateWithReceiver: receiver arguments: arguments withEvaluator: self at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitExplicitCastNode: node [
	self error: 'Cannot evaluate an unexpanded implicit cast.' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitFieldDefinitionNode: node [
	^ MbndValue value: nil type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitFunctionCallNode: node [
	| function arguments |
	self assert: node type isNotNil.
	function := self visitNode: node function.
	arguments := self visitNodesAndCollect: node arguments.
	^ function unwrapMbndValue evaluateApplicationWithArguments: arguments withEvaluator: self at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitFunctionDefinitionNode: node [
	^ self visitNode: node prototype
]

{ #category : #visiting }
MbndAstEvaluator >> visitFunctionPrototypeNode: node [
	self assert: node concreteMethod isNotNil.
	^ MbndValue value: node concreteMethod type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitGCClassDeclarationNode: node [
	^ self visitTypeDeclarationNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitGCClassDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitGlobalVariableDefinitionNode: node [
	self assert: node binding isNotNil.
	^ node binding asCompileTimeValueReferenceOfType: node type withEvaluator: self at: node

]

{ #category : #visiting }
MbndAstEvaluator >> visitIfConditionNode: node [
	| condition result |
	condition := self visitNode: node condition.
	
	result := condition unwrapMbndValue ifTrue: [
		node trueValue
			ifNotNil: [ :expression | self visitNode: expression ]
			ifNil: [ node type defaultValue ]
	] ifFalse: [ 
		node falseValue
			ifNotNil: [ :expression | self visitNode: expression ]
			ifNil: [ node type defaultValue ]
	].

	^ node type isVoidType ifTrue: [
		node type defaultValue
	] ifFalse: [
		result
	]
]

{ #category : #visiting }
MbndAstEvaluator >> visitImplicitCastNode: node [
	self error: 'Cannot evaluate an unexpanded implicit cast.' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitInlineAssembly: node [
	node isModuleLevelInlineAssembly ifTrue: [ ^ node type defaultValueAt: node ].
	self errorNotInCompileTime: 'Cannot evaluate inline assembly in compile time.' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitLexicalScopeNode: node [
	^ self withScope: (scope newLexicalScopeAt: node) do: [
		self visitNode: node expression
	]
]

{ #category : #visiting }
MbndAstEvaluator >> visitLiteralValueNode: node [
	^ node evaluateMbndValue
]

{ #category : #visiting }
MbndAstEvaluator >> visitLocalVariableDefinitionNode: node [
	self assert: node binding isNotNil.
	node binding isGlobalVariable ifTrue: [ ^ self visitGlobalVariableDefinitionNode: node ].
	
	self assert: node initialValue isNotNil.
	^ node binding evaluateLocalDefinition: node withEvaluator: self

]

{ #category : #visiting }
MbndAstEvaluator >> visitMacroMessageDefinitionNode: node [
	^ node prototype
]

{ #category : #visiting }
MbndAstEvaluator >> visitMessageDefinitionNode: node [
	^ self visitNode: node prototype
]

{ #category : #visiting }
MbndAstEvaluator >> visitMessagePrototypeNode: node [
	self assert: node concreteMethod isNotNil.
	^ MbndValue value: node concreteMethod type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitMethodReferenceNode: node [
	self assert: node binding isNotNil.
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitPointerAsReferenceNode: node [
	| pointer |
	pointer := self visitNode: node pointer.
	^ pointer copy
		type: pointer type asReferenceType;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitPointerReinterpretCastNode: node [
	| pointer |
	pointer := self visitNode: node expression.
	^ pointer copy
		type: node type;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitPredicatedTypeConceptDefinitionNode: node [
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitQuasiQuoteNode: node [
	| result |
	result := MbndAstQuasiQuoteEvaluator new
		unquoteEvaluator: self;
		visitNode: node expression.
	self assert: result isMbndAstNode.
	^ MbndValue value: result type: node type.
]

{ #category : #visiting }
MbndAstEvaluator >> visitQuoteNode: node [
	^ MbndValue value: node expression type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitReferenceAsPointerNode: node [
	| reference |
	reference := self visitNode: node reference.
	^ reference copy
		type: reference type asPointerType;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitReferenceLoadNode: node [
	| reference |
	reference := self visitNode: node reference.
	^ reference value value
]

{ #category : #visiting }
MbndAstEvaluator >> visitReinterpretCastNode: node [
	self error: 'Cannot evaluate an unexpanded reinterpret cast.' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitReturnStatementNode: node [
	| result |
	result := self visitNode: node expression.
	^ MbndEvaluationReturn new
		returnValue: result;
		targetReturnContext: scope returnContextScope;
		signal
]

{ #category : #visiting }
MbndAstEvaluator >> visitSequenceNode: node [
	| result |
	node elements ifEmpty: [
		^ MbndValue value: nil type: node type
	].

	result := nil.
	node elements do: [ :element |
		result := self visitNode: element 
	].
	^ result
]

{ #category : #visiting }
MbndAstEvaluator >> visitSetFieldValueNode: node [
	| aggregate newValue aggregateType field aggregateValue |
	aggregate := self visitNode: node aggregate.
	newValue := self visitNode: node newValue.
	aggregateType := node aggregate type withoutDecorations withoutReferences.
	field := node field.

	aggregateValue := aggregate.
	(aggregate type isPointerType or: [ aggregate type isReferenceType or: [aggregate type isTemporaryReferenceType]]) ifTrue: [
		self assert: aggregate type baseType isConstantType not.
		aggregateValue := aggregateValue "ref value" value "ref container" value.
	] ifFalse: [
		aggregate := aggregateValue := aggregateValue copy
	].
	
	self assert: aggregateValue type isAggregateType.
	aggregateValue slots at: field slotIndex + 1 put: newValue value.
	^ aggregate
	
]

{ #category : #visiting }
MbndAstEvaluator >> visitSignExtensionCastNode: node [
	self assert: node type isPrimitiveIntegerType.
	"Nothing special should be required here."
	^ self visitBitCastNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitStaticClassPointerCastNode: castNode [
	| pointer sourceType targetType targetSlotIndex |
	pointer := self visitNode: castNode expression.
	
	sourceType := castNode expression type asUndecoratedClassType.
	targetType := castNode targetType asUndecoratedClassType.
	
	"Is this an upcast?"
	(sourceType isSubtypeOf: targetType) ifTrue: [
		targetSlotIndex := sourceType slotLayout typeStartLocations at: targetType.
		targetSlotIndex == 0 ifTrue: [ ^ pointer copy type: castNode type ].
		
		self halt
	].

	"Is this a down cast?"
	(targetType isSubtypeOf: sourceType) ifTrue: [
		self halt.
	].

	self halt
]

{ #category : #visiting }
MbndAstEvaluator >> visitStructureDeclarationNode: node [
	^ self visitTypeDeclarationNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitStructureDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitTemplateDefinitionNode: node [
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTemporaryVariableNode: node [
	| defaultValue |
	defaultValue := node valueType defaultValueAt: node.
	defaultValue isAggregateTypeInstanceValue ifTrue: [
		^ MbndValue value: defaultValue copy type: node type
	].

	self halt
]

{ #category : #visiting }
MbndAstEvaluator >> visitTruncateCastNode: node [
	| originalValue truncatedValue bitSize |
	self assert: node type isPrimitiveIntegerType.
	originalValue := self visitNode: node expression.
	bitSize := node type instanceSize *8.
	truncatedValue := originalValue value bitAnd: (1 << bitSize) - 1.
	node type isSigned ifTrue: [
		| signBit |
		signBit := 1 << (bitSize - 1).
		truncatedValue := (truncatedValue bitAnd: signBit - 1) - 
			(truncatedValue bitAnd: signBit)
	].
	
	^ truncatedValue asMoebiusValueWithType: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTupleNode: node [
	| result |
	result := node elements collect: [ :el | (self visitNode: el) unwrapMbndValue ].
	^ MbndValue value: result type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTupleSplicingNode: node [
	| tuple |
	node elementIndex = 1 ifTrue: [ 
		tuple := self visitNode: node tupleExpression.
		scope setBinding: node storage: tuple.
	] ifFalse: [
		tuple := scope lookBindingStorage: node tupleExpression.
	].

	^ (tuple value at: node elementIndex) asMoebiusValueWithType: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTypeDeclarationNode: node [
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTypeDefinitionNode: node [
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnexpandedMessageSendNode: node [
	self compilerBugError: 'Macro that should have been expanded is not expanded' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnionDeclarationNode: node [
	^ self visitTypeDeclarationNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnionDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnwrapEnumValueCastNode: node [
	^ self visitBitCastNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitVariableReferenceNode: node [
	self assert: node binding isNotNil.
	^ node binding asCompileTimeValueReferenceOfType: node type withEvaluator: self at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitVectorConstructionNode: node [
	| vectorElements |
	vectorElements := OrderedCollection new.
	node elements do: [ :el |
		| element |
		element := self visitNode: el.
		element type isPrimitiveVectorType ifTrue: [
			vectorElements addAll: element slots
		] ifFalse: [ 
			vectorElements add: element unwrapMbndValue
		]
	].
	self assert: vectorElements size = node type elements.
	^ MbndVectorTypeInstanceValue new
		type: node type;
		slots: vectorElements asArray;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitWhileLoopNode: node [
	| loopContext hasReceivedBreak |
	loopContext := Object new.
	
	hasReceivedBreak := false.
	[
		hasReceivedBreak not and: [
			node condition
				ifNil: [ true ]
				ifNotNil: [(self visitNode: node condition) unwrapMbndValue]]
	] whileTrue: [
		[
			self withBreakAndContinueContext: loopContext do: [
				node action ifNotNil: [ :action | self visitNode: action ]
			]
		] on: MbndBlockExitAction do: [ :e |
			e blockContext == loopContext ifFalse: [
				^ e pass.
			].
		
			hasReceivedBreak := e isBreakAction.
		].
	
		hasReceivedBreak ifFalse: [
			node continueAction ifNotNil: [ :action | self visitNode: action ]
		].
	].

	^ node type defaultValue
]

{ #category : #visiting }
MbndAstEvaluator >> visitZeroExtensionCastNode: node [
	self assert: node type isPrimitiveIntegerType.
	"Nothing special should be required here."
	^ self visitBitCastNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> withBreakAndContinueContext: context do: aBlock [
	| oldBreakContext oldContinueContext |
	oldBreakContext := currentBreakContext.
	oldContinueContext := currentContinueContext.

	currentBreakContext := context.
	currentContinueContext := context.
	^ aBlock ensure: [
		currentBreakContext := oldBreakContext.
		currentContinueContext := oldContinueContext.
	]
	
]

{ #category : #visiting }
MbndAstEvaluator >> withScope: newEvaluationScope do: aBlock [
	| oldEvaluationScope |
	oldEvaluationScope := scope.
	scope := newEvaluationScope.
	
	^ aBlock ensure: [ 
		scope := oldEvaluationScope
	]
]
