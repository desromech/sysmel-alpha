"
I am an AST visitor that delegates most of its node visits into another visitor. I can be used for composing visitors.
"
Class {
	#name : #MbndAstDelegationVisitor,
	#superclass : #MbndAstVisitor,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #delegate }
MbndAstDelegationVisitor >> delegateNodeVisit: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitAggregateConstructionWithNamedElementsNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitAggregateConstructionWithOrderedElementsNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArgumentDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArrayConstructionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArrayElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArraySliceDecorationChangeCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArraySliceElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitAssignmentNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitAssociationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitBitCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitBlockClosureActivationAttemptNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitBlockClosureNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitBooleanToDynamicObjectCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitBreakStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCasesOfCaseNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCasesOfNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCaughtExceptionReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCharacterToDynamicObjectCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitClassDeclarationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitClassDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCompileTimeConstantDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitConcretizeUndefinedValueCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitContinueStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitConvertFromCompilerObjectCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitConvertToASTNodeCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitConvertToCompilerObjectCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCopyIntoTemporaryVariableNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDecorationChangeTypeCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDestructuringAssignmentNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDictionaryNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDiscardFragmentStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDoWhileLoopNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDynamicObjectToBooleanCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDynamicObjectToCharacterCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDynamicObjectToFloatCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDynamicObjectToIntegerCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitEnumDeclarationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitEnumDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExceptionCatchExpressionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExceptionScopeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExpandScalarToMatrixCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExpandScalarToVectorCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExpandedDynamicMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExpandedHostMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExpandedMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExplicitCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFieldDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFloatToDynamicObjectCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFloatingPointSizeCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFloatingPointToIntegerCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFunctionCallNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFunctionDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFunctionPrototypeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGCClassDeclarationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGCClassDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGCVariableDataArrayElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGetFieldReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGetFieldValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGetGCVariableDataArraySizeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitGlobalVariableDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIOChannelReceiveAction: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIOChannelSendAction: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIdentifierReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIfConditionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitImmediateBlockClosureActivationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitImplicitCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIndexTypeExpansionCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitInlineAssembly: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIntegerToDynamicObjectCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIntegerToFloatingPointCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIntegerToPointerCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitInterfaceDeclarationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitInterfaceDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLexicalScopeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLiteralArrayToArrayCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLiteralValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLocalVariableDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMacroExpansionInlineBlockNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMacroMessageDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMacroMessagePrototypeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMacroSendMessageWithArgumentsNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatchingMatchedValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixConstructionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixGetColumnNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixGetRowNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixMultiplicationOperationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixSetColumnValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixSetRowValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMatrixTransposeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessageChainMessageNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessageChainNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessageDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessagePrototypeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMetaBuilderInstanceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMethodReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitNamespaceDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitNodeWithDeferredAnalysis: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitNumberToBooleanCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingAnyPatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingBindingPatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingIntervalPatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingSameValuePatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingSetPatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingTuplePatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPatternMatchingVariantTypeSelectionPatternNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPointerAsReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPointerElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPointerReinterpretCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPointerToArraySliceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPointerToIntegerCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPragmaNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPredicatedTypeConceptDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitProgramEntityExtensionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitQuasiQuoteNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitQuasiUnquoteNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitQuoteNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReferenceAsPointerNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReferenceLoadNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReinterpretCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReturnStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSampleTextureWithDepthReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSampleTextureWithExplicitDerivativesNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSampleTextureWithExplicitLodNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSampleTextureWithImplicitLodNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSequenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSetFieldValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitShaderEntryPointInfoReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSignExtensionCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSpliceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitStaticClassPointerCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitStructureDeclarationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitStructureDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTemplateDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTemplatedMetaBuilderInstanceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTemporaryVariableNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitThisContextReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTruncateCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTupleElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTupleNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTupleSplicingNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTupleToArrayCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitUnexpandedMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitUnionDeclarationNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitUnionDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitUnwrapEnumValueCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVariableReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVariantBoxCreateNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVariantTypeSelectorExtractionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVariantUnboxingAssignmentReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVariantUnboxingNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVectorConstructionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVectorGetElementsNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVectorSetElementsNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitWhileLoopNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitWrapEnumValueCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitZeroExtensionCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> vistVAListEndExpressionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> vistVAListStartExpressionNode: node [
	^ self delegateNodeVisit: node
]
