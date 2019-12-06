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

{ #category : #visiting }
MbndAstNode >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #converting }
MbndAstNode >> asActualSourcePosition [
	^ position asActualSourcePosition
]

{ #category : #converting }
MbndAstNode >> asSourcePositionString [
	^ position asSourcePositionString
]

{ #category : #'as yet unclassified' }
MbndAstNode >> concretizeNodeWithAnalyzer: analyzer [
	^ self
]

{ #category : #'as yet unclassified' }
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
MbndAstNode >> isArgumentDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isArrayElementReferenceNode [
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
MbndAstNode >> isBlockClosureNode [
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

{ #category : #testing }
MbndAstNode >> isClassDeclarationNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isClassDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCleanUpScopeNode [
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
MbndAstNode >> isDecorationChangeTypeCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDictionaryNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDoWhileLoopNode [
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
MbndAstNode >> isExpandScalarToMatrixCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandScalarToVectorCastNode [
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
MbndAstNode >> isGCVariableDataArrayElementReferenceNode [
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
MbndAstNode >> isIntegerToFloatingPointCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIntegerToPointerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLexicalScopeNode [
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
MbndAstNode >> isMacroMessageDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroMessagePrototypeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroSendMessageWithArgumentsNode [
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
MbndAstNode >> isMessageDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMessagePrototypeNode [
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
MbndAstNode >> isNonConcreteNode [
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
MbndAstNode >> isPatternMatchingLiteralValuePatternNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPatternMatchingPatternNode [
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
MbndAstNode >> isPointerToIntegerCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPragmaNode [
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
MbndAstNode >> isTemplateDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTemplatedMetaBuilderInstanceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTruncateCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isTupleNode [
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
MbndAstNode >> isVariableReferenceNode [
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

{ #category : #'as yet unclassified' }
MbndAstNode >> lexicallyScoped [
	^ MbndAstLexicalScopeNode new
		position: position;
		expression: self;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstNode >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget astNodeType
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
MbndAstNode >> type [
	^ type
]

{ #category : #accessing }
MbndAstNode >> type: anObject [
	type := anObject
]
