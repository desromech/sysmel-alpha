"
I am a visitor that constructs a transformed AST without modifying the original AST.
"
Class {
	#name : #MbndAstTransformVisitor,
	#superclass : #MbndAstVisitor,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTransformVisitor >> visitAbstractClassDefinitionNode: node [
	^ node copy
		declaration: (node declaration ifNotNil: [:n | self visitNode: n]);
		superclass: (node superclass ifNotNil: [:n | self visitNode: n]);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitAbstractTypeDefinitionNode: node [
	^ node copy
		declaration: (node declaration ifNotNil: [:n | self visitNode: n]);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitAggregateConstructionWithNamedElementsNode: node [
	^ node copy
		aggregate: (node targetType isMbndAstNode
			ifTrue: [self visitNode: node aggregate]
			ifFalse: [node aggregate]);
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitAggregateConstructionWithOrderedElementsNode: node [
	^ node copy
		aggregate: (node targetType isMbndAstNode
			ifTrue: [self visitNode: node aggregate]
			ifFalse: [node aggregate]);
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitArgumentDefinitionNode: node [
	^ node copy
		name: (node name isMbndAstNode ifTrue: [ self visitNode: node name ] ifFalse: [node name]);
		valueType: (node valueType ifNotNil: [:vt | self visitNode: vt]);
		initialValue: (node initialValue ifNotNil: [:iv | self visitNode: iv]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitArrayConstructionNode: node [
	^ node copy
		elementType: (node elementType isMbndAstNode
			ifTrue: [ self visitNode: node elementType ]
			ifFalse: [node elementType]);
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitArrayElementReferenceNode: node [
	^ node copy
		container: (self visitNode: node container);
		index: (self visitNode: node index);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitArraySliceDecorationChangeCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitArraySliceElementReferenceNode: node [
	^ node copy
		container: (self visitNode: node container);
		index: (self visitNode: node index);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitAssignmentNode: node [
	^ node copy
		value: (self visitNode: node value);
		reference: (self visitNode: node reference);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitAssociationNode: node [
	^ node copy
		key: (node key ifNotNil: [:n | self visitNode: n]);
		value: (node value ifNotNil: [:n | self visitNode: n]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitBitCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitBlockClosureNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		returnType: (node returnType isMbndAstNode ifTrue: [ self visitNode: node returnType ]);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitBooleanToDynamicObjectCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitBreakStatementNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCasesOfCaseNode: node [
	^ node copy
		pattern: (self visitNode: node pattern);
		action: (self visitNode: node action);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCasesOfNode: node [
	^ node copy
		matchedExpression: (self visitNode: node matchedExpression);
		cases: (self visitNodesAndCollect: node cases);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCaughtExceptionReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCharacterToDynamicObjectCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitClassDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitClassDefinitionNode: node [
	^ self visitAbstractClassDefinitionNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCompileTimeConstantDefinitionNode: node [
	^ node copy
		value: (self visitNode: node value);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitConcretizeUndefinedValueCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitContinueStatementNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitConvertFromCompilerObjectCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitConvertToASTNodeCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitConvertToCompilerObjectCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCopyIntoTemporaryVariableNode: node [
	^ node copy
		value: (self visitNode: node value);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDecorationChangeTypeCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDestructuringAssignmentNode: node [
	^ node copy
		pattern: (self visitNode: node pattern);
		value: (self visitNode: node value);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDictionaryNode: node [
	^ node copy
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDoWhileLoopNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		action: (self visitNode: node action);
		continueAction: (node continueAction ifNotNil: [self visitNode: node continueAction]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDynamicObjectToBooleanCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDynamicObjectToCharacterCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDynamicObjectToFloatCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDynamicObjectToIntegerCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitEnumDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitEnumDefinitionNode: node [
	^ node copy
		declaration: (node declaration ifNotNil: [:n | self visitNode: n]);
		valueType: (node valueType ifNotNil: [:n | self visitNode: n]);
		values: (node values ifNotNil: [:n | n isMbndAstNode ifTrue: [ self visitNode: n ] ifFalse: [n]]);
		body: (node body ifNotNil: [:n | self visitNode: n]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExceptionCatchExpressionNode: node [
	^ node copy
		exceptionTypeExpression: (self visitNode: node exceptionTypeExpression);
		catchAction: (self visitNode: node catchAction);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExceptionScopeNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		catchExpressions: (self visitNodesAndCollect: node explicitCleanUpActions);
		explicitCleanUpActions: (self visitNodesAndCollect: node explicitCleanUpActions);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExpandScalarToMatrixCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExpandScalarToVectorCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExpandedDynamicMessageSendNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExpandedHostMessageSendNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExpandedMessageSendNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExplicitCastNode: node [
	^ self visitGenericCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFieldDefinitionNode: node [
	^ node copy
		initialValue: (node initialValue ifNotNil: [:initialValue | self visitNode: initialValue]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFloatToDynamicObjectCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFloatingPointSizeCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFloatingPointToIntegerCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionCallNode: node [
	^ node copy
		function: (self visitNode: node function);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionDefinitionNode: node [
	^ node copy
		prototype: (self visitNode: node prototype);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionPrototypeNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		returnType: (node returnType isMbndAstNode ifTrue: [self visitNode: node returnType]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGCClassDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGCClassDefinitionNode: node [
	^ self visitAbstractClassDefinitionNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGCVariableDataArrayElementReferenceNode: node [
	^ node copy
		container: (self visitNode: node container);
		index: (self visitNode: node index);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGenericCastNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		targetType: (node targetType isMbndAstNode
			ifTrue: [self visitNode: node targetType]
			ifFalse: [node targetType]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGetFieldReferenceNode: node [
	^ node copy
		aggregate: (self visitNode: node aggregate);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGetFieldValueNode: node [
	^ node copy
		aggregate: (self visitNode: node aggregate);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGetGCVariableDataArraySizeNode: node [
	^ node copy
		container: (self visitNode: node container);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitGlobalVariableDefinitionNode: node [
	^ node copy
		initialValue: (node initialValue ifNotNil: [:initialValue | self visitNode: initialValue]);
		constructionPriority: (node constructionPriority ifNotNil: [:cp | self visitNode: cp]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIOChannelReceiveAction: node [
	^ node copy
		channel: (self visitNode: node channel);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIOChannelSendAction: node [
	^ node copy
		channel: (self visitNode: node channel);
		message: (self visitNode: node message);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIdentifierReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIfConditionNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		trueValue:  (self visitNode: node trueValue);
		falseValue: (self visitNode: node falseValue);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitImmediateBlockClosureActivationNode: node [
	^ node copy
		blockNode: (self visitNode: node blockNode);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitImplicitCastNode: node [
	^ self visitGenericCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitInlineAssembly: node [
	^ node copy
		architecture: (self visitNode: node architecture);
		dialect: (self visitNode: node dialect);
		inputList: (self visitNode: node inputList);
		outputList: (self visitNode: node outputList);
		clobberList: (self visitNode: node clobberList);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIntegerToDynamicObjectCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIntegerToFloatingPointCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIntegerToPointerCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitInterfaceDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitInterfaceDefinitionNode: node [
	^ self visitAbstractTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitLexicalScopeNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		explicitCleanUpActions: (self visitNodesAndCollect: node explicitCleanUpActions);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitLiteralArrayToArrayCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitLiteralValueNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitLocalVariableDefinitionNode: node [
	^ node copy
		initialValue: (node initialValue ifNotNil: [:initialValue | self visitNode: initialValue]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMacroExpansionInlineBlockNode: node [
	^ node copy
		blockNode: (self visitNode: node blockNode);
		argumentNodes: (self visitNodesAndCollect: node argumentNodes);
		ensureNode: (node ensureNode ifNotNil: [:en | self visitNode: en]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMacroMessageDefinitionNode: node [
	^ node copy
		prototype: (self visitNode: node prototype);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMacroMessagePrototypeNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		returnType: (node returnType isMbndAstNode ifTrue: [self visitNode: node returnType]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMacroSendMessageWithArgumentsNode: node [
	^ node copy
		selector: (self visitNode: node selector);
		receiver: (self visitNode: node receiver);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatchingMatchedValueNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixConstructionNode: node [
	^ node copy
		matrixType: (node matrixType isMbndAstNode
			ifTrue: [ self visitNode: node matrixType ]
			ifFalse: [node matrixType]);
		columns: (self visitNodesAndCollect: node columns);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixGetColumnNode: node [
	^ node copy
		matrix: (self visitNode: node matrix);
		element: (self visitNode: node element);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixGetRowNode: node [
	^ node copy
		matrix: (self visitNode: node matrix);
		element: (self visitNode: node element);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixMultiplicationOperationNode: node [
	^ node copy
		leftMatrix: (self visitNode: node leftMatrix);
		rightMatrix: (self visitNode: node rightMatrix);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixSetColumnValueNode: node [
	^ node copy
		matrix: (self visitNode: node matrix);
		element: (self visitNode: node element);
		value: (self visitNode: node value);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixSetRowValueNode: node [
	^ node copy
		matrix: (self visitNode: node matrix);
		element: (self visitNode: node element);
		value: (self visitNode: node value);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMatrixTransposeNode: node [
	^ node copy
		matrix: (self visitNode: node matrix);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageChainMessageNode: node [
	^ node copy
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageChainNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		messages: (self visitNodesAndCollect: node messages);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageDefinitionNode: node [
	^ node copy
		prototype: (self visitNode: node prototype);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessagePrototypeNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		returnType: (node returnType isMbndAstNode ifTrue: [self visitNode: node returnType]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMetaBuilderInstanceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMethodReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitNamespaceDefinitionNode: node [
	^ node copy
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitNodeWithDeferredAnalysis: node [
	^ node copy
		node: (self visitNode: node node);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitNumberToBooleanCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingAnyPatternNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingBindingPatternNode: node [
	^ node copy
		valuePattern: (node valuePattern ifNotNil: [:n | self visitNode: n]);
		requiredType: (node requiredType ifNotNil: [:n | n isMbndAstNode ifTrue: [self visitNode: n] ifFalse: [n]]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingIntervalPatternNode: node [
	^ node copy
		start: (self visitNode: node start);
		stop: (self visitNode: node start);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingLiteralValuePatternNode: node [
	^ node copy
		value: (self visitNode: node value);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingNeverPatternNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingSameValuePatternNode: node [
	^ node copy
		expectedValue: (self visitNode: node expectedValue);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingSetPatternNode: node [
	^ node copy
		elements: (self visitNodes: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPatternMatchingTuplePatternNode: node [
	^ node copy
		expectedElements: (self visitNodes: node expectedElements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPointerAsReferenceNode: node [
	^ node copy
		pointer: (self visitNode: node pointer);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPointerElementReferenceNode: node [
	^ node copy
		container: (self visitNode: node container);
		index: (self visitNode: node index);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPointerReinterpretCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPointerToArraySliceNode: node [
	^ node copy
		pointer: (self analyzeNodeIfNeeded: node pointer);
		firstIndex: (self analyzeNodeIfNeeded: node firstIndex);
		lastIndex: (self analyzeNodeIfNeeded: node lastIndex);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPointerToIntegerCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPragmaNode: node [
	^ node copy
		selector: (node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPredicatedTypeConceptDefinitionNode: node [
	^ node copy
		predicate: (self visitNode: node predicate);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitProgramEntityExtensionNode: node [
	^ node copy
		programEntity: (node programEntity isMbndAstNode
			ifTrue: [ self visitNode: node programEntity ]
			ifFalse: [ node programEntity ]);
		body: (self visitNode: node body)
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitQuasiQuoteNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitQuasiUnquoteNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitQuoteNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitReferenceAsPointerNode: node [
	^ node copy
		reference: (self visitNode: node reference);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitReferenceLoadNode: node [
	^ node copy
		reference: (self visitNode: node reference);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitReinterpretCastNode: node [
	^ self visitGenericCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitReturnStatementNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSampleTextureWithExplicitDerivativesNode: node [
	^ node copy
		sampler: (self visitNode: node sampler);
		texture: (self visitNode: node texture);
		texcoord: (self visitNode: node texcoord);
		dtdx: (self visitNode: node dtdx);
		dtdy: (self visitNode: node dtdy);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSampleTextureWithExplicitLodNode: node [
	^ node copy
		sampler: (self visitNode: node sampler);
		texture: (self visitNode: node texture);
		texcoord: (self visitNode: node texcoord);
		lod: (self visitNode: node lod);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSampleTextureWithImplicitLodNode: node [
	^ node copy
		sampler: (self visitNode: node sampler);
		texture: (self visitNode: node texture);
		texcoord: (self visitNode: node texcoord);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSequenceNode: node [
	^ node copy
		pragmas: (self visitNodesAndCollect: node pragmas);
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSetFieldValueNode: node [
	^ node copy
		aggregate: (self visitNode: node aggregate);
		newValue: (self visitNode: node newValue);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitShaderEntryPointInfoReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSignExtensionCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSpecificCastNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		targetType: (node targetType isMbndAstNode
			ifTrue: [self visitNode: node targetType]
			ifFalse: [node targetType]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSpliceNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitStaticClassPointerCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitStructureDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitStructureDefinitionNode: node [
	^ self visitAbstractTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTemplateDefinitionNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTemplatedMetaBuilderInstanceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTemporaryVariableNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTraitDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTraitDefinitionNode: node [
	^ self visitAbstractTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTruncateCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTupleElementReferenceNode: node [
	^ node copy
		container: (self visitNode: node container);
		index: (self visitNode: node index);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTupleNode: node [
	^ node copy
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTupleSplicingNode: node [
	 self error: 'Cannot transform this node.'
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTupleToArrayCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitUnexpandedMessageSendNode: node [
	^ node copy
		receiver: (node receiver ifNotNil: [self visitNode: node receiver]);
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitUnionDeclarationNode: node [
	^ node copy
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitUnionDefinitionNode: node [
	^ node copy
		declaration: (node declaration ifNotNil: [:n | self visitNode: n]);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitUnwrapEnumValueCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVariableReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVariantBoxCreateNode: node [
	^ node copy
		variantType: (node variantType isMbndAstNode
			ifTrue: [ self visitNode: node variantType ]
			ifFalse: [ node variantType ]);
		typeSelector: (node typeSelector isMbndAstNode
			ifTrue: [ self visitNode: node typeSelector ]
			ifFalse: [node typeSelector]);
		boxedValue: (self visitNode: node boxedValue);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVariantTypeSelectorExtractionNode: node [
	^ node copy
		variant: (self visitNode: node variant);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVariantUnboxingAssignmentReferenceNode: node [
	^ self visitVariantUnboxingNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVariantUnboxingNode: node [
	^ node copy
		variant: (self visitNode: node variant);
		typeSelector: (node typeSelector isMbndAstNode
			ifTrue: [ self visitNode: node typeSelector ]
			ifFalse: [node typeSelector]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVectorConstructionNode: node [
	^ node copy
		vectorType: (node vectorType isMbndAstNode
			ifTrue: [ self visitNode: node vectorType ]
			ifFalse: [node vectorType]);
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVectorGetElementsNode: node [
	^ node copy
		vector: (self visitNode: node vector);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVectorSetElementsNode: node [
	^ node copy
		vector: (self visitNode: node vector);
		values: (self visitNodesAndCollect: node values);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitWhileLoopNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		action: (self visitNode: node action);
		continueAction: (self visitNode: node continueAction);
		yourself 
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitWrapEnumValueCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitZeroExtensionCastNode: node [
	^ self visitSpecificCastNode: node
]

{ #category : #visiting }
MbndAstTransformVisitor >> vistVAListEndExpressionNode: node [
	^ node copy
		valist: (self visitNode: node valist);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> vistVAListStartExpressionNode: node [
	^ node copy
		valist: (self visitNode: node valist);
		yourself
]
