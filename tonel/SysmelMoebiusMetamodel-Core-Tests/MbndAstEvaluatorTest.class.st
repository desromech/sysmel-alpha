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

{ #category : #'as yet unclassified' }
MbndAstEvaluatorTest >> countTwiceFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #destCount type: compilationTarget int32Type.
	}.
	body := builder sequence: {
		(builder defineLocalVariable: #i withValueType: nil withInitialValue: (builder literalInteger: 0))
			mutable.
		(builder defineLocalVariable: #count withValueType: nil withInitialValue: (builder literalInteger: 0))
			mutable.
			
		builder while: (builder unexpandedSend: (builder literalSymbol: #<)
			to: (builder identifier: #i) withArguments: {(builder identifier: #destCount)})
			do: (builder sequence: {
				builder unexpandedSend: (builder literalSymbol: #assignValue:)
					to:  (builder identifier: #count)
					withArguments: {
						builder unexpandedSend: (builder literalSymbol: #+)
							to: (builder identifier: #count) withArguments: { builder literalInteger: 2 }.
					}
			}) continueWith: (builder unexpandedSend: (builder literalSymbol: #assignValue:)
					to:  (builder identifier: #i)
					withArguments: {
						builder unexpandedSend: (builder literalSymbol: #+)
							to: (builder identifier: #i) withArguments: { builder literalInteger: 1 }.
					}).
		builder identifier: #count
	}.
	
	^ builder functionNamed: #countTwice arguments: arguments returnType: compilationTarget int32Type definitionBody: body
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

{ #category : #accessing }
MbndAstEvaluatorTest >> minFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #a type: compilationTarget int32Type.
		builder argument: #b type: compilationTarget int32Type.
	}.
	body := builder if: (builder unexpandedSend: (builder literalSymbol: #<=)
			to: (builder identifier: #a) withArguments: { builder identifier: #b })
		trueValue: (builder identifier: #a) falseValue: (builder identifier: #b).
	^ builder functionNamed: #min arguments: arguments returnType: compilationTarget int32Type definitionBody: body
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

{ #category : #running }
MbndAstEvaluatorTest >> testCountTwiceFunctionCall [
	| node value |
	node := builder sequence: {
		self countTwiceFunctionDefinitionNode.
		builder call: (builder identifier: #countTwice) arguments: { 
			builder literalInteger: 10.
		}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 20.

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
MbndAstEvaluatorTest >> testGlobalDeclaration [
	| node value |
	node := builder sequence: { 
		builder defineGlobalVariable: #x withValueType: nil withInitialValue: (builder literalInteger: 5).
		builder identifier: #x
	}.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 5.

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
MbndAstEvaluatorTest >> testLocalVariableMutableAssignment [
	| node value |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder reference: (builder identifier: #x) assignValue: (builder literalInteger: 42).
		builder referenceLoad: (builder identifier: #x)
	}.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value value equals: 42.
	self assert: value type isPrimitiveIntegerType.
]

{ #category : #running }
MbndAstEvaluatorTest >> testLocalVariableMutableReferenceImplicitLoad [
	| node value |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder unexpandedSend: (builder literalSymbol: #+)
			to: (builder identifier: #x)
			withArguments: { 
			(builder literalInteger: 1)
		}
	}.
	
	value := self analyzeAndEvaluateAST: node.
	self assert: value value equals: 6.
	self assert: value type isPrimitiveIntegerType.
]

{ #category : #running }
MbndAstEvaluatorTest >> testMinFunctionCall [
	| node value |
	node := builder sequence: {
		self minFunctionDefinitionNode.
		builder call: (builder identifier: #min) arguments: { 
			builder literalInteger: 2.
			builder literalInteger: 3
		}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 2.

]

{ #category : #running }
MbndAstEvaluatorTest >> testMinFunctionCall2 [
	| node value |
	node := builder sequence: {
		self minFunctionDefinitionNode.
		builder call: (builder identifier: #min) arguments: { 
			builder literalInteger: 3.
			builder literalInteger: 2
		}
	}.
		
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isPrimitiveIntegerType.
	self assert: value value equals: 2.

]

{ #category : #running }
MbndAstEvaluatorTest >> testNew [
	self assert: evaluator scope equals: scope
]

{ #category : #running }
MbndAstEvaluatorTest >> testQuasiQuoteLiteral [
	| node literal value |
	literal := builder literalInteger: 42.
	node := builder quasiQuote: literal.
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isASTNodeType.
	self assert: value value equals: literal.

]

{ #category : #running }
MbndAstEvaluatorTest >> testQuasiQuoteUnquoteQuoteLiteral [
	| node literal value |
	literal := builder literalInteger: 42.
	node := builder quasiQuote: (builder quasiUnquote: (builder quote: literal)).
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isASTNodeType.
	self assert: value value equals: literal.

]

{ #category : #running }
MbndAstEvaluatorTest >> testQuote [
	| literal node value |
	literal := builder literalInteger: 42.
	node := builder quote: literal.
	value := self analyzeAndEvaluateAST: node.
	self assert: value type isASTNodeType.
	self assert: value value equals: literal.

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
