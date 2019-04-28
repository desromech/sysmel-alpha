"
A MbndAstEvaluatorTest is a test class for testing the behavior of MbndAstEvaluator
"
Class {
	#name : #MbndAstEvaluatorTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'scope',
		'returnContext',
		'compilationTarget',
		'analyzer',
		'evaluator'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-Evaluation'
}

{ #category : #running }
MbndAstEvaluatorTest >> analyzeAndEvaluateAST: node [
	^ evaluator visitNode: (analyzer visitNode: node)
]

{ #category : #tests }
MbndAstEvaluatorTest >> identityFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	^ builder functionNamed: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #running }
MbndAstEvaluatorTest >> identityMessageDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	^ builder messageSelector: #identity: arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #tests }
MbndAstEvaluatorTest >> returnSquareFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder return: (
		builder unexpandedSend: (builder literalSymbol: #*)
			to: (builder identifier: #x)
			withArguments: {builder identifier: #x}).
	^ builder functionNamed: #square arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #running }
MbndAstEvaluatorTest >> setUp [
	super setUp.
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
	builder := MbndAstBuilder forModule: module.

	scope := module newGenericAnalysisScope.
	returnContext := scope returnContextScope.

	analyzer := MbndAstSemanticAnalyzer new scope: scope; module: module.
	evaluator := MbndAstEvaluator new scope: scope.
]

{ #category : #tests }
MbndAstEvaluatorTest >> testDummyLexicalScopeNode [
	| node result |
	node := builder lexicalScope: (builder sequence: {
		builder literalInteger: 1.
		builder literalInteger: 42
	}).
	result := self analyzeAndEvaluateAST: node.
	self assert: result value equals: 42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #running }
MbndAstEvaluatorTest >> testEmptySequence [
	| node value |
	node := builder sequence: { }.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isVoidType.
	self assert: value value equals: nil.

]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityFunctionApplySend [
	| node value |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder unexpandedSend: (builder literalSymbol: #applyWithArguments:)
			to: (builder identifier: #identity)
			withArguments: {builder tuple: { 
				builder literalInteger: 5
			}}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 5.

]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityFunctionCall [
	| node value |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder call: (builder identifier: #identity) arguments: { 
			builder literalInteger: 5
		}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 5.

]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityFunctionDefinitionNode [
	| node value arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder functionNamed: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isReferenceType.
	self assert: value type baseType isFunctionType.

]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityFunctionPrototypeNode [
	| node value arguments |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	node := builder functionPrototypeNamed: #identity arguments: arguments returnType: compilationTarget int32Type.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isReferenceType.
	self assert: value type baseType isFunctionType.
]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityFunctionReference [
	| node value |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder identifier: #identity
	}.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isReferenceType.
	self assert: value type baseType isFunctionType.
]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityMessageDefinitionNode [
	| node value arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder messageSelector: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isReferenceType.
	self assert: value type baseType isFunctionType.

]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityMessagePrototypeNode [
	| node value arguments |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	node := builder messagePrototypeSelector: #identity arguments: arguments returnType: compilationTarget int32Type.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isReferenceType.
	self assert: value type baseType isFunctionType.
]

{ #category : #running }
MbndAstEvaluatorTest >> testIdentityMessageSend [
	| node value |
	node := builder sequence: {
		self identityMessageDefinitionNode.
		builder unexpandedSend: (builder literalSymbol: #identity:) to: nil withArguments: { 
			builder literalInteger: 5
		}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 5.

]

{ #category : #running }
MbndAstEvaluatorTest >> testLiteral [
	| literal value |
	literal := builder literalInteger: 42.
	value := self analyzeAndEvaluateAST: literal.
	self assert: value unwrapMbndValue equals: 42
]

{ #category : #running }
MbndAstEvaluatorTest >> testLocalDeclaration [
	| node value |
	node := builder sequence: { 
		builder defineLocalVariable: #x withValueType: nil withInitialValue: (builder literalInteger: 5).
		builder identifier: #x
	}.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 5.

]

{ #category : #running }
MbndAstEvaluatorTest >> testNew [
	self assert: evaluator scope equals: scope
]

{ #category : #running }
MbndAstEvaluatorTest >> testReturn [
	| node |
	node := builder return: (builder literalInteger: 42).
	[
		self analyzeAndEvaluateAST: node
	] on: MbndEvaluationReturn do: [ :e |
		self assert: e targetReturnContext equals: returnContext.
		self assert: e returnValue unwrapMbndValue equals: 42
	].
	
]

{ #category : #running }
MbndAstEvaluatorTest >> testSequence [
	| node value |
	node := builder sequence: { 
		builder literalInteger: 1.
		builder literalInteger: 2.
		builder literalInteger: 42.
	}.
	
	value := evaluator visitNode: node.
	self assert: value type isLiteralIntegerType.
	self assert: value value equals: 42.

]

{ #category : #running }
MbndAstEvaluatorTest >> testSquareFunctionCall [
	| node value |
	node := builder sequence: {
		self returnSquareFunctionDefinitionNode.
		builder call: (builder identifier: #square) arguments: { 
			builder literalInteger: 5
		}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 25.

]
