"
A MbndAstTransformVisitorTest is a test class for testing the behavior of MbndAstTransformVisitor
"
Class {
	#name : #MbndAstTransformVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'visitor'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-AST'
}

{ #category : #running }
MbndAstTransformVisitorTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	visitor := MbndAstTransformVisitor new.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testBreakStatement [
	| node transformedNode |
	node := builder breakStatement.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCasesOfCaseNode [
	| node transformedNode action pattern |
	pattern := builder literalInteger: 42.
	action := builder literalInteger: 1.
	node := builder casesOfCase: pattern do: action.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode pattern equals: pattern.
	self assert: transformedNode action equals: action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCasesOfDefaultCaseNode [
	| node transformedNode action |
	action := builder literalInteger: 1.
	node := builder casesOfDefaultCaseDo: action.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode action equals: action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCasesOfNode [
	| node transformedNode firstCase secondCase matchedExpression |
	firstCase := builder casesOfCase: (builder literalInteger: 1) do: (builder literalInteger: 2).
	secondCase := builder casesOfCase: (builder literalInteger: 3) do: (builder literalInteger: 4).
	matchedExpression := builder identifier: #someElement.
	
	node := builder casesOf: matchedExpression cases: { firstCase . secondCase }.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode matchedExpression equals: matchedExpression.
	self assert: transformedNode cases first pattern equals: firstCase pattern.
	self assert: transformedNode cases first action equals: firstCase action.
	self assert: transformedNode cases second pattern equals: secondCase pattern.
	self assert: transformedNode cases second action equals: secondCase action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testContinueStatement [
	| node transformedNode |
	node := builder continueStatement.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testDoWhileLoopNode [
	| node transformedNode condition action |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 42.

	node := builder do: action while: condition.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode condition equals: node condition.
	self assert: transformedNode action equals: node action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testExpandedMessageSendNode [
	| node transformedNode receiver selector arguments |
	receiver := builder literalInteger: 1.
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	node := builder unexpandedSend: selector to: receiver withArguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode receiver equals: node receiver.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFunctionCallNode [
	| node transformedNode function arguments |
	function := builder identifier: #sqrt.
	arguments := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.

	node := builder call: function arguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode function equals: function.
	self assert: transformedNode arguments equals: arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIdentifierReference [
	| node transformedNode |
	node := builder identifier: #ident.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIfConditionNode [
	| node transformedNode condition trueValue falseValue |
	condition := builder identifier: #predicate.
	trueValue := builder literalInteger: 1.
	falseValue := builder literalInteger: 2.
	
	node := builder if: condition trueValue: trueValue falseValue: falseValue.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode condition equals: node condition.
	self assert: transformedNode trueValue equals: node trueValue.
	self assert: transformedNode falseValue equals: node falseValue.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testLexicalScopeNode [
	| node transformedNode scoped |
	scoped := builder identifier: #predicate.

	node := scoped lexicallyScoped.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: scoped.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testLiteralValueNode [
	| node transformedNode |
	node := builder literalInteger: 1.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testLocalVariableDefinition [
	| node valueType initialValue transformedNode |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineLocalVariable: #var withValueType: valueType withInitialValue: initialValue.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode name equals: node name.
	self assert: transformedNode valueType equals: valueType.
	self assert: transformedNode initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessageChainMessageNode [
	| node transformedNode selector arguments |
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	node := builder messageChainMessageSelector: selector arguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessageChainNode [
	| node transformedNode selector arguments receiver chainedMessage |
	receiver := builder literalInteger: -1.
	
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	chainedMessage := builder messageChainMessageSelector: selector arguments: arguments.
	node := builder messageChainReceiver: receiver messages: { chainedMessage }.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode receiver equals: receiver.
	self assert: transformedNode messages first selector equals: chainedMessage selector.
	self assert: transformedNode messages first arguments equals: chainedMessage arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMetaBuilderInstanceNode [
	| node transformedNode |
	node := MbndAstMetaBuilderInstanceNode new instance: 42.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode == node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testPragmaNode [
	| node transformedNode selector arguments |
	selector := #somePragma:withArg:.
	arguments := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmaSelector: selector arguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testQuasiQuoteNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder quasiQuote: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testQuasiUnquoteNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder quasiUnquote: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testQuoteNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder quote: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testReturnStatementNode [
	| node transformedNode pragmaNode elements |
	pragmaNode := builder pragmaSelector: #pragma:withArg arguments: {
		builder literalInteger: -1.
		builder literalInteger: -2.
	}.
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmas: { pragmaNode } sequence: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode pragmas first selector equals: pragmaNode selector.
	self assert: transformedNode pragmas first arguments equals: pragmaNode arguments.
	self assert: transformedNode elements equals: elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSequenceNode [
	| node transformedNode pragmaNode elements |
	pragmaNode := builder pragmaSelector: #pragma:withArg arguments: {
		builder literalInteger: -1.
		builder literalInteger: -2.
	}.
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmas: { pragmaNode } sequence: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode pragmas first selector equals: pragmaNode selector.
	self assert: transformedNode pragmas first arguments equals: pragmaNode arguments.
	self assert: transformedNode elements equals: elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSpliceNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder splice: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testUnexpandedMessageSendNode [
	| node transformedNode receiver selector arguments |
	receiver := builder literalInteger: 1.
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	node := builder send: selector to: receiver withArguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode receiver equals: node receiver.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testWhileLoopNode [
	| node transformedNode condition action |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 42.

	node := builder while: condition do: action.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode condition equals: node condition.
	self assert: transformedNode action equals: node action.
]
