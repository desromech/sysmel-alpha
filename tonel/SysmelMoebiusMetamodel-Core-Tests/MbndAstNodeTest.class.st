"
A MbndAstNodeTest is a test class for testing the behavior of MbndAstNode
"
Class {
	#name : #MbndAstNodeTest,
	#superclass : #TestCase,
	#category : #'SysmelMoebiusMetamodel-Core-Tests-AST'
}

{ #category : #tests }
MbndAstNodeTest >> testEmptyPosition [
	| node |
	node := MbndAstNode new.
	self assert: node position isNotNil.
]

{ #category : #tests }
MbndAstNodeTest >> testEmptyTupleParseAsFunctionArgumentsPrototype [
	| tuple arguments |
	tuple := MbndAstTupleNode new.
	arguments := tuple parseAsFunctionArgumentsPrototype.
	self assert: arguments isSequenceable.
	self assert: arguments isEmpty.

]

{ #category : #tests }
MbndAstNodeTest >> testIdentifierParseAsFunctionArgumentsPrototype [
	| identifier arguments |
	identifier := MbndAstIdentifierReferenceNode new symbol: #x.
	
	arguments := identifier parseAsFunctionArgumentsPrototype.
	self assert: arguments size equals: 1.
	self assert: arguments first name equals: #x.
	self assert: arguments first valueType equals: nil.
]

{ #category : #tests }
MbndAstNodeTest >> testMessageSendParseAsFunctionArgumentsPrototype [
	| message arguments builder module |
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	message := builder unexpandedSend: (builder literalSymbol: #x:) to: nil withArguments: {
			builder identifier: #Int32
		}.
	arguments := message parseAsFunctionArgumentsPrototype.
	self assert: arguments size equals: 1.
	self assert: arguments first name equals: #x.
	self assert: arguments first valueType isIdentifierReferenceNode.
	self assert: arguments first valueType symbol equals: #Int32.

]

{ #category : #tests }
MbndAstNodeTest >> testMetaBuilderInstanceNode [
	self assert: MbndAstMetaBuilderInstanceNode new isMetaBuilderInstanceNode
]

{ #category : #tests }
MbndAstNodeTest >> testParseAsFunctionArgumentsPrototype [
	self should: [ MbndAstNode new parseAsFunctionArgumentsPrototype ] raise: Error.
]

{ #category : #tests }
MbndAstNodeTest >> testTestingMethods [
	| node |
	node := MbndAstNode new.
	
	self deny: 1 isMbndAstNode.
	self assert: node isMbndAstNode.
	self deny: node isArrayElementReferenceNode.
	self deny: node isAbstractCastNode.
	self deny: node isArgumentDefinitionNode.
	self deny: node isAbstractTypeDefinitionNode.
	self deny: node isAssociationNode.
	self deny: node isAssignmentNode.
	self deny: node isBitCastNode.
	self deny: node isBreakStatementNode.
	self deny: node isBoundIdentifierReferenceNode.
	self deny: node isBlockClosureNode.
	self deny: node isCasesOfCaseNode.
	self deny: node isCasesOfNode.
	self deny: node isClassDeclarationNode.
	self deny: node isClassDefinitionNode.
	self deny: node isCleanUpScopeNode.
	self deny: node isCompileTimeConstantDefinitionNode.
	self deny: node isConcretizeUndefinedValueCastNode.
	self deny: node isContinueStatementNode.
	self deny: node isConvertToASTNodeCastNode.
	self deny: node isDictionaryNode.
	self deny: node isDoWhileLoopNode.
	self deny: node isEnumDeclarationNode.
	self deny: node isEnumDefinitionNode.
	self deny: node isExpandedMessageSendNode.
	self deny: node isExplicitCastNode.
	self deny: node isFloatingPointToIntegerCastNode.
	self deny: node isFloatingPointSizeCastNode.
	self deny: node isFieldDefinitionNode.
	self deny: node isFunctionCallNode.
	self deny: node isFunctionDefinitionNode.
	self deny: node isFunctionPrototypeNode.
	self deny: node isGCClassDeclarationNode.
	self deny: node isGCClassDefinitionNode.
	self deny: node isGenericCastNode.
	self deny: node isGetGCVariableDataArraySizeNode.
	self deny: node isGlobalVariableDefinitionNode.
	self deny: node isIdentifierReferenceNode.
	self deny: node isIfConditionNode.
	self deny: node isIntegerToFloatingPointCastNode.
	self deny: node isIntegerToPointerCastNode.
	self deny: node isImmediateBlockClosureActivationNode.
	self deny: node isImplicitCastNode.
	self deny: node isIOChannelActionNode.
	self deny: node isIOChannelReceiveActionNode.
	self deny: node isIOChannelSendActionNode.
	self deny: node isLexicalScopeNode.
	self deny: node isLiteralValueNode.
	self deny: node isLiteralSymbolValueNode.
	self deny: node isLiteralArrayToArrayCastNode.
	self deny: node isLocalVariableDefinitionNode.
	self deny: node isNamespaceDefinitionNode.
	self deny: node isMacroExpansionInlineBlockNode.
	self deny: node isMacroSendMessageWithArgumentsNode.
	self deny: node isMacroMessageDefinitionNode.
	self deny: node isMacroMessagePrototypeNode.
	self deny: node isMatrixConstructionNode.
	self deny: node isMatrixGetColumnNode.
	self deny: node isMatrixGetRowNode.
	self deny: node isMatrixMultiplicationOperationNode.
	self deny: node isMatrixSetColumnValueNode.
	self deny: node isMatrixSetRowValueNode.
	self deny: node isMetaBuilderInstanceNode.
	self deny: node isMessageChainNode.
	self deny: node isMessageChainMessageNode.
	self deny: node isMessageDefinitionNode.
	self deny: node isMessagePrototypeNode.
	self deny: node isMethodReferenceNode.
	self deny: node isNumericalCastNode.
	self deny: node isPragmaNode.
	self deny: node isProgramEntityExtensionNode.
	self deny: node isPointerElementReferenceNode.
	self deny: node isPointerAsReferenceNode.
	self deny: node isQuasiQuoteNode.
	self deny: node isQuasiUnquoteNode.
	self deny: node isQuoteNode.
	self deny: node isPointerReinterpretCastNode.
	self deny: node isPointerToIntegerCastNode.
	self deny: node isReferenceAsPointerNode.
	self deny: node isReinterpretCastNode.
	self deny: node isReturnStatementNode.
	self deny: node isReferenceLoadNode.
	self deny: node isSampleTextureWithExplicitDerivativesNode.
	self deny: node isSampleTextureWithExplicitLodNode.
	self deny: node isSampleTextureWithImplicitLodNode.
	self deny: node isSequenceNode.
	self deny: node isSpecificCastNode.
	self deny: node isSignExtensionCastNode.
	self deny: node isSpliceNode.
	self deny: node isStaticClassPointerCastNode.
	self deny: node isStructureDeclarationNode.
	self deny: node isStructureDefinitionNode.
	self deny: node isSubscriptElementReferenceNode .
	self deny: node isTemplatedMetaBuilderInstanceNode.
	self deny: node isTemplateDefinitionNode.
	self deny: node isTruncateCastNode.
	self deny: node isTupleNode.
	self deny: node isTupleToArrayCastNode.
	self deny: node isUnexpandedMessageSendNode.
	self deny: node isUnionDeclarationNode.
	self deny: node isUnionDefinitionNode.
	self deny: node isUnwrapEnumValueNode.
	self deny: node isWhileLoopNode.
	self deny: node isWrapEnumValueNode.
	self deny: node isVariableReferenceNode.
	self deny: node isVectorConstructionNode.
	self deny: node isVectorGetElementsNode.
	self deny: node isVectorSetElementsNode.
	self deny: node isZeroExtensionCastNode.
	

]

{ #category : #tests }
MbndAstNodeTest >> testTupleIdentifiersParseAsFunctionArgumentsPrototype [
	| tuple arguments builder |
	builder := MbndAstBuilder new.
	tuple := builder tuple: {
		builder identifier: #x.
		builder identifier: #y.
	}.
	arguments := tuple parseAsFunctionArgumentsPrototype.
	self assert: arguments size equals: 2.
	self assert: arguments first name equals: #x.
	self assert: arguments first valueType equals: nil.

	self assert: arguments second name equals: #y.
	self assert: arguments second valueType equals: nil.

]

{ #category : #tests }
MbndAstNodeTest >> testTupleSendsParseAsFunctionArgumentsPrototype [
	| tuple arguments module builder |
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	tuple := builder tuple: {
		builder unexpandedSend: (builder literalSymbol: #x:) to: nil withArguments: {
			builder identifier: #Int32
		}.
		builder unexpandedSend: (builder literalSymbol: #y:) to: nil withArguments: {
			builder identifier: #Int64
		}.
	}.
	arguments := tuple parseAsFunctionArgumentsPrototype.
	self assert: arguments size equals: 2.
	self assert: arguments first name equals: #x.
	self assert: arguments first valueType isIdentifierReferenceNode.
	self assert: arguments first valueType symbol equals: #Int32.

	self assert: arguments second name equals: #y.
	self assert: arguments second valueType isIdentifierReferenceNode.
	self assert: arguments second valueType symbol equals: #Int64.

]
