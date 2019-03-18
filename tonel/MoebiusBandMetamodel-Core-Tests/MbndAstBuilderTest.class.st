"
A MbndAstBuilderTest is a test class for testing the behavior of MbndAstBuilder
"
Class {
	#name : #MbndAstBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'builder',
		'module'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-AST'
}

{ #category : #running }
MbndAstBuilderTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	
]

{ #category : #running }
MbndAstBuilderTest >> testBreakStatementNode [
	| node |
	node := builder breakStatement.
	self assert: node isBreakStatementNode.
]

{ #category : #running }
MbndAstBuilderTest >> testCasesOfCaseNode [
	| node action pattern |
	action := builder literalInteger: 1.
	pattern := builder literalInteger: 2.
	node := builder casesOfCase: pattern do: action.
	
	self assert: node isCasesOfCaseNode.
	self assert: node pattern equals: pattern.
	self assert: node action equals: action.
]

{ #category : #running }
MbndAstBuilderTest >> testCasesOfDefaultCaseNode [
	| node action |
	action := builder literalInteger: 1.
	node := builder casesOfDefaultCaseDo: action.
	
	self assert: node isCasesOfDefaultCaseNode.
	self assert: node action equals: action.
]

{ #category : #running }
MbndAstBuilderTest >> testContinueStatementNode [
	| node |
	node := builder continueStatement.
	self assert: node isContinueStatementNode.
]

{ #category : #running }
MbndAstBuilderTest >> testExpandedMessageNode [
	| node receiver arguments |
	receiver := builder literalInteger: 1.
	arguments := { 
		builder literalInteger: 4.
		builder literalInteger: 2
	}.

	node := builder send: #to:by: to: receiver withArguments: arguments.
	self assert: node isExpandedMessageSendNode .
	self deny: node isUnexpandedMessageSendNode .
	self assert: node receiver equals: receiver.
	self assert: node arguments equals: arguments.
]

{ #category : #running }
MbndAstBuilderTest >> testFunctionCallNode [
	| node function arguments |
	function := builder identifier: #sqrt.
	arguments := { 
		builder literalFloat: 4.0.
	}.

	node := builder call: function arguments: arguments.
	self assert: node isFunctionCallNode.
	self assert: node function equals: function.
	self assert: node arguments equals: arguments.
]

{ #category : #running }
MbndAstBuilderTest >> testIdentifier [
	| node |
	node := builder identifier: #symbol.
	self assert: node isIdentifierReferenceNode.
	self assert: node symbol equals: #symbol.
]

{ #category : #running }
MbndAstBuilderTest >> testIfConditionNode [
	| node condition trueValue falseValue |
	condition := builder identifier: #predicate.
	trueValue := builder identifier: #trueValue.
	falseValue := builder identifier: #falseValue.
	node := builder if: condition trueValue: trueValue falseValue: falseValue.
	
	self assert: node isIfConditionNode.
	self assert: node condition equals: condition.
	self assert: node trueValue equals: trueValue.
	self assert: node falseValue equals: falseValue.
]

{ #category : #running }
MbndAstBuilderTest >> testLexicalScope2Node [
	| node expression |
	expression := builder identifier: #hello.
	node := expression lexicallyScoped.

	self assert: node isLexicalScopeNode.
	self assert: node expression equals: expression.
]

{ #category : #running }
MbndAstBuilderTest >> testLexicalScopeNode [
	| node expression |
	expression := builder identifier: #hello.
	node := builder lexicalScope: expression.

	self assert: node isLexicalScopeNode.
	self assert: node expression equals: expression.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralBoolean [
	| node |
	node := builder literalBoolean: true.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanTrueType.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralBoolean2 [
	| node |
	node := builder literalBoolean: false.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanFalseType.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralFalse [
	| node |
	node := builder literalBooleanFalse.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanFalseType.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralFloat [
	| node |
	node := builder literalFloat: 1.5.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.5.
	self assert: node type isLiteralFloatType.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralInteger [
	| node |
	node := builder literalInteger: 1.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.
	self assert: node type isLiteralIntegerType.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralTrue [
	| node |
	node := builder literalBooleanTrue.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanTrueType.
]

{ #category : #running }
MbndAstBuilderTest >> testMessageChainMessageNode [
	| node arguments |
	arguments := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	node := builder messageChainMessageSelector: #by:to: arguments: arguments.
	
	self assert: node isMessageChainMessageNode.
	self assert: node selector equals: #by:to:.
	self assert: node arguments equals: arguments.
]

{ #category : #running }
MbndAstBuilderTest >> testMessageChainNode [
	| node chainedMessages receiver |
	chainedMessages := { 
		builder messageChainMessageSelector: #by:to: arguments: {
			builder literalInteger: 1.
			builder literalInteger: 2.
		}.
		
		builder messageChainMessageSelector: #yourself: arguments: #()
	}.
	
	receiver := builder literalInteger: 1.
	node := builder messageChainReceiver: receiver messages: chainedMessages.
	self assert: node isMessageChainNode.
	self assert: node receiver equals: receiver.
	self assert: node messages equals: chainedMessages.
]

{ #category : #running }
MbndAstBuilderTest >> testPragmaNode [
	| node arguments |
	arguments := {
		builder literalInteger: 1.
		builder literalInteger: 2
	}.
	
	node := builder pragmaSelector: #somePragma:with: arguments: arguments.

	self assert: node isPragmaNode.
	self assert: node selector equals: #somePragma:with:.
	self assert: node arguments equals: arguments.
]

{ #category : #running }
MbndAstBuilderTest >> testQuasiQuoteNode [
	| node quoted |
	quoted := builder literalInteger: 1.
	node := builder quasiQuote: quoted.

	self assert: node isQuasiQuoteNode.
	self assert: node expression equals: quoted.
]

{ #category : #running }
MbndAstBuilderTest >> testQuasiUnquoteNode [
	| node expression |
	expression := builder literalInteger: 1.
	node := builder quasiUnquote: expression.

	self assert: node isQuasiUnquoteNode.
	self assert: node expression equals: expression.
]

{ #category : #running }
MbndAstBuilderTest >> testQuoteNode [
	| node quoted |
	quoted := builder literalInteger: 1.
	node := builder quote: quoted.

	self assert: node isQuoteNode.
	self assert: node expression equals: quoted.
]

{ #category : #running }
MbndAstBuilderTest >> testSequenceNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder sequence: { one . two }.
	
	self assert: node isSequenceNode.
	self assert: node elements equals: {one . two}.
]

{ #category : #running }
MbndAstBuilderTest >> testSequenceWithPragmaNode [
	| pragmas expressions node |
	pragmas := { 
		builder pragmaSelector: #nullaryPragma arguments: #().
		builder pragmaSelector: #unaryPragma arguments: {
			builder literalInteger: 42.
		}
	}.
	
	expressions := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmas: pragmas sequence: expressions.
	
	self assert: node isSequenceNode.
	self assert: node pragmas equals: pragmas.
	self assert: node elements equals: expressions.
]

{ #category : #running }
MbndAstBuilderTest >> testSpliceNode [
	| node expression |
	expression := builder literalInteger: 1.
	node := builder splice: expression.

	self assert: node isSpliceNode.
	self assert: node expression equals: expression.
]

{ #category : #running }
MbndAstBuilderTest >> testUnexpandedMessageNode [
	| node receiver arguments |
	receiver := builder literalInteger: 1.
	arguments := { 
		builder literalInteger: 4.
		builder literalInteger: 2
	}.

	node := builder unexpandedSend: #to:by: to: receiver withArguments: arguments.
	self assert: node isUnexpandedMessageSendNode .
	self deny: node isExpandedMessageSendNode .
	self assert: node receiver equals: receiver.
	self assert: node arguments equals: arguments.
]
