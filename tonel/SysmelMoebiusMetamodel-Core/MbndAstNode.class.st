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

{ #category : #visiting }
MbndAstNode >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MbndAstNode >> concretizeNodeWithAnalyzer: analyzer [
	^ self
]

{ #category : #initialization }
MbndAstNode >> initialize [
	super initialize.
	position := MbndSourcePosition empty.
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
MbndAstNode >> isCastNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCompileTimeConstantDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isContinueStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDoWhileLoopNode [
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
MbndAstNode >> isIdentifierReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIfConditionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isImplicitCastNode [
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
MbndAstNode >> isMacroMessageDefinitionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMacroMessagePrototypeNode [
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
MbndAstNode >> isPointerElementReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPragmaNode [
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
MbndAstNode >> isSequenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSpliceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSubscriptElementReferenceNode [
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
MbndAstNode >> isVariableReferenceNode [
	^ false

]

{ #category : #testing }
MbndAstNode >> isWhileLoopNode [
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
	position := anObject
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
