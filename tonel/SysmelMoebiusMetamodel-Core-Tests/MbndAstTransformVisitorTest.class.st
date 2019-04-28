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
MbndAstTransformVisitorTest >> testArgumentDefinition [
	| node type transformedNode |
	type := builder identifier: #Int32.
	node := builder argument: #x type: type.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isArgumentDefinitionNode.
	self assert: transformedNode name equals: #x.
	self assert: transformedNode valueType equals: type.

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
MbndAstTransformVisitorTest >> testCompileTimeConstantDefinition [
	| node transformedNode value |
	value := builder identifier: #Int32.
	node := builder alias: #Int definition: value.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isCompileTimeConstantDefinitionNode.
	self assert: transformedNode name equals: #Int.
	self assert: transformedNode value equals: value.

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
MbndAstTransformVisitorTest >> testFunctionDefinitionNode [
	| returnType definition body transformedNode |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder functionNamed: #zero arguments: #() returnType: returnType definitionBody: body.
	transformedNode := visitor visitNode: definition.
	self assert: transformedNode ~~ definition.
	self assert: transformedNode prototype ~~ definition prototype.
	self assert: transformedNode isFunctionDefinitionNode.
	self assert: transformedNode prototype isFunctionPrototypeNode.
	self assert: transformedNode name equals: #zero.
	self assert: transformedNode arguments equals: #().
	self assert: transformedNode returnType equals: returnType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFunctionPrototypeNode [
	| arguments returnType prototype transformedNode |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := (builder identifier: #Int32).
	prototype := builder functionPrototypeNamed: #add arguments: arguments returnType: returnType.
	transformedNode := visitor visitNode: prototype.
	self assert: transformedNode ~~ prototype.
	self assert: transformedNode isFunctionPrototypeNode.
	self assert: transformedNode name equals: prototype name.

	self assert: transformedNode arguments first ~~ arguments first.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode arguments first type equals: arguments first type.

	self assert: transformedNode arguments second ~~ arguments second.
	self assert: transformedNode arguments second name equals: arguments second name.
	self assert: transformedNode arguments second type equals: arguments second type.

	self assert: transformedNode returnType equals: returnType.
	
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
MbndAstTransformVisitorTest >> testMessageDefinitionNode [
	| returnType definition body transformedNode |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder messageSelector: #zero arguments: #() returnType: returnType definitionBody: body.
	transformedNode := visitor visitNode: definition.
	self assert: transformedNode ~~ definition.
	self assert: transformedNode prototype ~~ definition prototype.
	self assert: transformedNode isMessageDefinitionNode.
	self assert: transformedNode prototype isMessagePrototypeNode.
	self assert: transformedNode selector equals: #zero.
	self assert: transformedNode arguments equals: #().
	self assert: transformedNode returnType equals: returnType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessagePrototypeNode [
	| arguments returnType prototype transformedNode |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := (builder identifier: #Int32).
	prototype := builder messagePrototypeSelector: #+ arguments: arguments returnType: returnType.
	transformedNode := visitor visitNode: prototype.
	self assert: transformedNode ~~ prototype.
	self assert: transformedNode isMessagePrototypeNode.
	self assert: transformedNode selector equals: prototype selector.

	self assert: transformedNode arguments first ~~ arguments first.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode arguments first type equals: arguments first type.

	self assert: transformedNode arguments second ~~ arguments second.
	self assert: transformedNode arguments second name equals: arguments second name.
	self assert: transformedNode arguments second type equals: arguments second type.

	self assert: transformedNode returnType equals: returnType.
	
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMetaBuilderInstanceNode [
	| node transformedNode |
	node := MbndAstMetaBuilderInstanceNode new instance: 42.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode == node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testNamespaceDefinition [
	| node transformedNode body |
	body := builder literalInteger: 42.
	node := builder namespace: #HelloNamespace definition: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isNamespaceDefinitionNode.
	self assert: transformedNode name equals: #HelloNamespace.
	self assert: transformedNode body equals: body.

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
MbndAstTransformVisitorTest >> testTupleNode [
	| node transformedNode elements |
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder tuple: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode elements equals: elements.
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
MbndAstTransformVisitorTest >> testVariableReference [
	| node transformedNode dummyBinding |
	dummyBinding := MbndFunctionLocalVariable new
		valueType: module compilationTarget int32Type;
		type: module compilationTarget int32Type ref;
		yourself.
	node := builder variableReference: dummyBinding.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode binding equals: node binding.
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
