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
MbndAstNodeTest >> testMetaBuilderInstanceNode [
	self assert: MbndAstMetaBuilderInstanceNode new isMetaBuilderInstanceNode
]

{ #category : #tests }
MbndAstNodeTest >> testTestingMethods [
	| node |
	node := MbndAstNode new.
	
	self deny: 1 isMbndAstNode.
	self assert: node isMbndAstNode.
	self deny: node isArgumentDefinitionNode.
	self deny: node isBreakStatementNode.
	self deny: node isBoundIdentifierReferenceNode.
	self deny: node isVariableReferenceNode.
	self deny: node isCasesOfCaseNode.
	self deny: node isCasesOfDefaultCaseNode.
	self deny: node isCasesOfNode.
	self deny: node isContinueStatementNode.
	self deny: node isDoWhileLoopNode.
	self deny: node isExpandedMessageSendNode.
	self deny: node isFunctionCallNode.
	self deny: node isFunctionDefinitionNode.
	self deny: node isFunctionPrototypeNode.
	self deny: node isIdentifierReferenceNode.
	self deny: node isIfConditionNode.
	self deny: node isLexicalScopeNode.
	self deny: node isLiteralValueNode.
	self deny: node isLiteralSymbolValueNode.
	self deny: node isLocalVariableDefinitionNode.
	self deny: node isMetaBuilderInstanceNode.
	self deny: node isMessageChainNode.
	self deny: node isMessageChainMessageNode.
	self deny: node isMessageDefinitionNode.
	self deny: node isMessagePrototypeNode.
	self deny: node isPragmaNode.
	self deny: node isQuasiQuoteNode.
	self deny: node isQuasiUnquoteNode.
	self deny: node isQuoteNode.
	self deny: node isReturnStatementNode.
	self deny: node isSequenceNode.
	self deny: node isSpliceNode.
	self deny: node isStatementNode.
	self deny: node isTupleNode.
	self deny: node isUnexpandedMessageSendNode.
	self deny: node isWhileLoopNode.
]
