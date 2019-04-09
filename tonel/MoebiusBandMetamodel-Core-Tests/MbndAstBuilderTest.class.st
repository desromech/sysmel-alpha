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

{ #category : #tests }
MbndAstBuilderTest >> testBreakStatementNode [
	| node |
	node := builder breakStatement.
	self assert: node isBreakStatementNode.
]

{ #category : #tests }
MbndAstBuilderTest >> testCasesOfCaseNode [
	| node action pattern |
	action := builder literalInteger: 1.
	pattern := builder literalInteger: 2.
	node := builder casesOfCase: pattern do: action.
	
	self assert: node isCasesOfCaseNode.
	self assert: node pattern equals: pattern.
	self assert: node action equals: action.
]

{ #category : #tests }
MbndAstBuilderTest >> testCasesOfDefaultCaseNode [
	| node action |
	action := builder literalInteger: 1.
	node := builder casesOfDefaultCaseDo: action.
	
	self assert: node isCasesOfDefaultCaseNode.
	self assert: node action equals: action.
]

{ #category : #tests }
MbndAstBuilderTest >> testCasesOfNode [
	| node firstCase secondCase matchedExpression |
	firstCase := builder casesOfCase: (builder literalInteger: 1) do: (builder literalInteger: 2).
	secondCase := builder casesOfCase: (builder literalInteger: 3) do: (builder literalInteger: 4).
	matchedExpression := builder identifier: #someElement.
	
	node := builder casesOf: matchedExpression cases: { firstCase . secondCase }.

	self assert: node isCasesOfNode.
	self assert: node matchedExpression equals: matchedExpression.
	self assert: node cases first equals: firstCase.
	self assert: node cases second equals: secondCase.
]

{ #category : #tests }
MbndAstBuilderTest >> testContinueStatementNode [
	| node |
	node := builder continueStatement.
	self assert: node isContinueStatementNode.
]

{ #category : #tests }
MbndAstBuilderTest >> testDoWhileLoopNode [
	| node condition action |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 1.
	node := builder do: action while: condition.
	
	self assert: node isDoWhileLoopNode.
	self assert: node condition equals: condition.
	self assert: node action equals: action.
]

{ #category : #tests }
MbndAstBuilderTest >> testExpandedMessageNode [
	| node receiver arguments selector |
	receiver := builder literalInteger: 1.
	arguments := { 
		builder literalInteger: 4.
		builder literalInteger: 2
	}.

	selector := builder literalSymbol: #to:by:.
	node := builder send: selector to: receiver withArguments: arguments.
	self assert: node isExpandedMessageSendNode .
	self deny: node isUnexpandedMessageSendNode .
	self assert: node receiver equals: receiver.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
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

{ #category : #tests }
MbndAstBuilderTest >> testIdentifier [
	| node |
	node := builder identifier: #symbol.
	self assert: node isIdentifierReferenceNode.
	self assert: node symbol equals: #symbol.
]

{ #category : #tests }
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

{ #category : #tests }
MbndAstBuilderTest >> testLexicalScope2Node [
	| node expression |
	expression := builder identifier: #hello.
	node := expression lexicallyScoped.

	self assert: node isLexicalScopeNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testLexicalScopeNode [
	| node expression |
	expression := builder identifier: #hello.
	node := builder lexicalScope: expression.

	self assert: node isLexicalScopeNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralBoolean [
	| node |
	node := builder literalBoolean: true.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanTrueType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralBoolean2 [
	| node |
	node := builder literalBoolean: false.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanFalseType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralFalse [
	| node |
	node := builder literalBooleanFalse.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanFalseType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralFloat [
	| node |
	node := builder literalFloat: 1.5.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.5.
	self assert: node type isLiteralFloatType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralInteger [
	| node |
	node := builder literalInteger: 1.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.
	self assert: node type isLiteralIntegerType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralSymbol [
	| node |
	node := builder literalSymbol: #a.
	self assert: node isLiteralValueNode.
	self assert: node isLiteralSymbolValueNode.
	self assert: node value equals: #a.
	self assert: node type isLiteralSymbolType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralTrue [
	| node |
	node := builder literalBooleanTrue.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanTrueType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralUndefined [
	| node |
	node := builder literalUndefined.
	self assert: node isLiteralValueNode.
	self assert: node value equals: nil.
	self assert: node type isUndefinedType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralVoid [
	| node |
	node := builder literalVoid.
	self assert: node isLiteralValueNode.
	self assert: node value equals: nil.
	self assert: node type isVoidType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLocalVariableDefinition [
	| node valueType initialValue |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineLocalVariable: #var withValueType: valueType withInitialValue: initialValue.
	self assert: node isLocalVariableDefinitionNode.
	self assert: node name equals: #var.
	self assert: node valueType equals: valueType.
	self assert: node initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessageChainMessageNode [
	| node arguments selector |
	arguments := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	selector := builder literalSymbol: #selector.
	node := builder messageChainMessageSelector: selector arguments: arguments.
	
	self assert: node isMessageChainMessageNode.
	self assert: node selector equals: selector.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessageChainNode [
	| node chainedMessages receiver |
	chainedMessages := { 
		builder messageChainMessageSelector: (builder literalSymbol: #by:to:) arguments: {
			builder literalInteger: 1.
			builder literalInteger: 2.
		}.
		
		builder messageChainMessageSelector: (builder literalSymbol: #yourself:) arguments: #()
	}.
	
	receiver := builder literalInteger: 1.
	node := builder messageChainReceiver: receiver messages: chainedMessages.
	self assert: node isMessageChainNode.
	self assert: node receiver equals: receiver.
	self assert: node messages equals: chainedMessages.
]

{ #category : #tests }
MbndAstBuilderTest >> testModule [
	self assert: builder module equals: module
]

{ #category : #tests }
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

{ #category : #tests }
MbndAstBuilderTest >> testQuasiQuoteNode [
	| node quoted |
	quoted := builder literalInteger: 1.
	node := builder quasiQuote: quoted.

	self assert: node isQuasiQuoteNode.
	self assert: node expression equals: quoted.
]

{ #category : #tests }
MbndAstBuilderTest >> testQuasiUnquoteNode [
	| node expression |
	expression := builder literalInteger: 1.
	node := builder quasiUnquote: expression.

	self assert: node isQuasiUnquoteNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testQuoteNode [
	| node quoted |
	quoted := builder literalInteger: 1.
	node := builder quote: quoted.

	self assert: node isQuoteNode.
	self assert: node expression equals: quoted.
]

{ #category : #tests }
MbndAstBuilderTest >> testReturnNode [
	| node expression |
	expression := builder identifier: #predicate.
	node := builder return: expression.
	
	self assert: node isReturnStatementNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testSequenceNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder sequence: { one . two }.
	
	self assert: node isSequenceNode.
	self assert: node elements equals: {one . two}.
]

{ #category : #tests }
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

{ #category : #tests }
MbndAstBuilderTest >> testSpliceNode [
	| node expression |
	expression := builder literalInteger: 1.
	node := builder splice: expression.

	self assert: node isSpliceNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testUnexpandedMessageNode [
	| node receiver arguments selector |
	receiver := builder literalInteger: 1.
	arguments := { 
		builder literalInteger: 4.
		builder literalInteger: 2
	}.

	selector := builder literalSymbol: #to:by:.
	node := builder unexpandedSend: #selector to: receiver withArguments: arguments.
	self assert: node isUnexpandedMessageSendNode .
	self deny: node isExpandedMessageSendNode .
	self assert: node receiver equals: receiver.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testWhileLoopNode [
	| node condition action |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 1.
	node := builder while: condition do: action.
	
	self assert: node isWhileLoopNode.
	self assert: node condition equals: condition.
	self assert: node action equals: action.
]
