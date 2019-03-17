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
MbndAstBuilderTest >> testSequenceNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder sequence: { one . two }.
	
	self assert: node isSequenceNode.
	self assert: node elements equals: {one . two}.
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
