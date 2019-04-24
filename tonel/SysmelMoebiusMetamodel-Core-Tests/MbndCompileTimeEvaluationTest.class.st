Class {
	#name : #MbndCompileTimeEvaluationTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-Module'
}

{ #category : #running }
MbndCompileTimeEvaluationTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testAddInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #+) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 4.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testDivideInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #/) to:
		(builder literalInteger: -6) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testLexicallyScopedLiteral [
	| ast result |
	ast := (builder literalInteger: 42) lexicallyScoped.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testLiteralInteger [
	| ast result |
	ast := builder literalInteger: 42.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testMultiplyInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #*) to:
		(builder literalInteger: 2) withArguments: {
			builder literalInteger: -3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -6.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testNegateInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #negated) to:
		(builder literalInteger: 42) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testReturn [
	| ast result |
	ast := builder sequence: {
		builder return: (builder literalInteger: 42).
		builder literalInteger: 0
	}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSequenceOfLiterals [
	| ast result |
	ast := builder sequence: {
		builder literalInteger: 1.
		builder literalInteger: 2.
		builder literalInteger: 42.
	}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSequenceOfSequenceLiterals [
	| ast result |
	ast := builder sequence: {
		builder sequence: { 
			builder literalInteger: 1.
			builder literalInteger: 2.
		}.
		builder literalInteger: 42.
	}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSubtractInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #-) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedAddInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #+) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 4.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedDivideInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #/) to:
		(builder literalInteger: -6) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedMultiplyInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #*) to:
		(builder literalInteger: 2) withArguments: {
			builder literalInteger: -3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -6.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedNegateInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #negated) to:
		(builder literalInteger: 42) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -42.
	self assert: result type isLiteralIntegerType
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedSubtractInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #-) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isLiteralIntegerType.
]
