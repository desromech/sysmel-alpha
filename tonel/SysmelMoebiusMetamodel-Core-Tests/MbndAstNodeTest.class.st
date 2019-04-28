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
	self deny: node isCompileTimeConstantDefinitionNode.
	self deny: node isArgumentDefinitionNode.
	self deny: node isBreakStatementNode.
	self deny: node isBoundIdentifierReferenceNode.
	self deny: node isVariableReferenceNode.
	self deny: node isMethodReferenceNode.
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
	self deny: node isNamespaceDefinitionNode.
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
