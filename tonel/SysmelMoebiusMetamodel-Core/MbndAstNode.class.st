"
I represent a generic AST node in the MoebiusBand meta model. I am used to implement language agnostic macro expansion.
"
Class {
	#name : #MbndAstNode,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'position',
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'instance creation' }
MbndAstNode class >> dummy [
	"I am any null node that answers to the AST node protocol."
	^ self new
]

{ #category : #serialization }
MbndAstNode class >> messagePackTypeName [
	self assert: (name beginsWith: 'MbndAst').
	^ (self name allButFirst: 'MbndAst' size) asSymbol
]

{ #category : #visiting }
MbndAstNode >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #converting }
MbndAstNode >> asActualSourcePosition [
	^ position asActualSourcePosition
]

{ #category : #converting }
MbndAstNode >> asLiteralSymbolNodeFor: aCompilationTarget [
	<compileTime>
	<returnType: #_ASTNodeType>
	self error: 'Cannot convert ast node {1} into a literal symbol ast node.' format: {self asString} at: self
]

{ #category : #composition }
MbndAstNode >> asSequenceWithoutLexicalScope [
	<compileTime>
	<returnType: #_ASTNodeType>
	^ self
]

{ #category : #converting }
MbndAstNode >> asSourcePositionString [
	^ position asSourcePositionString
]

{ #category : #composition }
MbndAstNode >> calledFunctionBinding [
	^ nil
]

{ #category : #composition }
MbndAstNode >> concretizeNodeWithAnalyzer: analyzer [
	^ self
]

{ #category : #copying }
MbndAstNode >> copyWithConcreteSourcePosition: aPosition [
	aPosition isEmptySourcePosition ifTrue: [ ^ self ].
	^ self copy
		position: aPosition;
		yourself
]

{ #category : #serialization }
MbndAstNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#type . type encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #serialization }
MbndAstNode >> encodeGraphForMessagePackWith: graphEncoder [
	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [self encodeFieldsForMessagePackWith: graphEncoder]
]

{ #category : #testing }
MbndAstNode >> hasEmptySourcePosition [
	^ position isEmptySourcePosition
]

{ #category : #composition }
MbndAstNode >> inferTemplateKindWithCompilationTarget: compilationTarget [
	^ compilationTarget templateType
]

{ #category : #initialization }
MbndAstNode >> initialize [
	super initialize.
	position := MbndSourcePosition empty.
]

{ #category : #testing }
MbndAstNode >> isAbstractCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isAbstractTypeDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isAggregateConstructionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isAggregateConstructionWithNamedElementsNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isAggregateConstructionWithOrderedElementsNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isArgumentDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isArrayConstructionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isArrayElementReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isArraySliceDecorationChangeCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isArraySliceElementReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isAssignmentNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isAssociationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isBitCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isBlockClosureActivationAttemptNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isBlockClosureNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isBooleanToDynamicObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isBoundIdentifierReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isBreakStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCasesOfCaseNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCasesOfDefaultCaseNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCasesOfNode [
	^ false
]

{ #category : #visiting }
MbndAstNode >> isCaughtExceptionReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCharacterToDynamicObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isClassDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isClassDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCompileTimeConstantDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isConcretizeUndefinedValueCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isContinueStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isConvertFromCompilerObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isConvertToASTNodeCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isConvertToCompilerObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCopyIntoTemporaryVariableNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDecorationChangeTypeCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDestructuringAssignmentNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDictionaryNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDiscardFragmentStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDoWhileLoopNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDynamicObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDynamicObjectToBooleanCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDynamicObjectToCharacterCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDynamicObjectToFloatCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDynamicObjectToIntegerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isEmptySourcePosition [
	^ false
]

{ #category : #testing }
MbndAstNode >> isEnumDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isEnumDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExceptionCatchExpressionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExceptionScopeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandScalarToMatrixCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandScalarToVectorCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandedDynamicMessageSendNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandedHostMessageSendNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandedMessageSendNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExplicitCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFieldDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFloatingPointSizeCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFloatingPointToDynamicObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFloatingPointToIntegerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFunctionCallNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFunctionDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFunctionPrototypeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGCClassDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGCClassDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGeneratedIdentifierNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGenericCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGetFieldReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGetFieldValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGetGCVariableDataArraySizeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isGlobalVariableDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIOChannelActionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIOChannelReceiveActionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIOChannelSendActionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIdentifierReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIfConditionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isImmediateBlockClosureActivationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isImplicitCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIndexTypeExpansionCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isInlineAssembly [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIntegerToDynamicObjectCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIntegerToFloatingPointCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIntegerToPointerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isInterfaceDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isInterfaceDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLexicalScopeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLiteralArrayToArrayCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLiteralSymbolValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLiteralValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLocalVariableDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroExpansionInlineBlockNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroMessageMethodDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroMessageMethodPrototypeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroSendMessageNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroSendMessageWithArgumentsNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatchingMatchedValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixConstructionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixGetColumnNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixGetRowNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixMultiplicationOperationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixSetColumnValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixSetRowValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMatrixTransposeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMbndAstNode [
	^ true
]

{ #category : #testing }
MbndAstNode >> isMessageChainMessageNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMessageChainNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMessageMethodDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMessageMethodPrototypeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMetaBuilderInstanceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMethodReferenceNode [
	^ false

]

{ #category : #testing }
MbndAstNode >> isNamespaceDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isNodeWithDeferredAnalysis [
	^ false
]

{ #category : #testing }
MbndAstNode >> isNonConcreteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isNumberToBooleanCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isNumericalCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingBindingPatternNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingIntervalPatternNode [
	^ true
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingLiteralValuePatternNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingPatternNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingSetValuePatternNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPointerAsReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPointerElementReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPointerReinterpretCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPointerToArraySliceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPointerToIntegerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPragmaNode [
	^ false
]

{ #category : #visiting }
MbndAstNode >> isPredicatedTypeConceptDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isProgramEntityExtensionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isQuasiQuoteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isQuasiUnquoteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isQuoteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isReferenceAsPointerNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isReferenceLoadNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isReinterpretCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isReturnStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSampleTextureWithDepthReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSampleTextureWithExplicitDerivativesNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSampleTextureWithExplicitLodNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSampleTextureWithImplicitLodNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSequenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSetFieldValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isShaderEntryPointInfoReferenceNode [
	^ false

]

{ #category : #testing }
MbndAstNode >> isSignExtensionCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSpecificCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSpliceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isStaticClassPointerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isStructureDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isStructureDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSubscriptElementReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSuperReference [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTemplateDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTemplatedMetaBuilderInstanceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTemporaryReferenceLoadNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTemporaryVariableNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isThisContextReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTraitDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTraitDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTruncateCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTupleElementReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTupleNode [
	^ false
]

{ #category : #visiting }
MbndAstNode >> isTupleSplicingNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTupleToArrayCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isUnexpandedMessageSendNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isUnionDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isUnionDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isUnwrapEnumValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVAListEndExpressionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVAListExpressionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVAListStartExpressionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVariableReferenceNode [
	^ false

]

{ #category : #visiting }
MbndAstNode >> isVariantBoxCreateNode [
	^ false
]

{ #category : #visiting }
MbndAstNode >> isVariantTypeSelectorExtractionNode [
	^ false
]

{ #category : #visiting }
MbndAstNode >> isVariantUnboxingAssignmentReferenceNode [
	^ false
]

{ #category : #visiting }
MbndAstNode >> isVariantUnboxingNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVectorConstructionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVectorGetElementsNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isVectorSetElementsNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isWhileLoopNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isWrapEnumValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isZeroExtensionCastNode [
	^ false
]

{ #category : #composition }
MbndAstNode >> lexicallyScoped [
	^ MbndAstLexicalScopeNode new
		position: position;
		expression: self;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstNode >> markStorageCreationNodeForCopyEllision: storageCreationNode [
	"By default, do nothing."
	"Transcript show: self class name; cr."
]

{ #category : #serialization }
MbndAstNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	type := encodedFields at: #type.
	position := graphDecoder moduleLocation.
]

{ #category : #composition }
MbndAstNode >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget astNodeType
]

{ #category : #serialization }
MbndAstNode >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #composition }
MbndAstNode >> originalSourceCode [
	<compileTime>
	^ position originalSourceCode
]

{ #category : #parsing }
MbndAstNode >> parseAsArgumentDefinition [
	self error: 'Expected an argument definition.' at: self
]

{ #category : #parsing }
MbndAstNode >> parseAsFunctionArgumentsPrototype [
	self error: 'Expected a function arguments prototype.' at: self
]

{ #category : #accessing }
MbndAstNode >> position [
	^ position
]

{ #category : #accessing }
MbndAstNode >> position: anObject [
	anObject == false ifTrue: [ self halt ].
	position := anObject
]

{ #category : #accessing }
MbndAstNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ absentBlock value
]

{ #category : #printing }
MbndAstNode >> printValueString [
	^ self printString
]

{ #category : #accessing }
MbndAstNode >> sourceTextPosition [
	^ position sourceTextPosition
]

{ #category : #'as yet unclassified' }
MbndAstNode >> storageDestinationForRecursion [
	^ nil
]

{ #category : #accessing }
MbndAstNode >> type [
	^ type
]

{ #category : #accessing }
MbndAstNode >> type: anObject [
	type := anObject
]

{ #category : #composition }
MbndAstNode >> withNextExpression: anotherNode [
	<compileTime>
	<returnType: #_ASTNodeType>
	^ MbndAstSequenceNode new
		position: self;
		elements: { self . anotherNode };
		yourself
	
]
