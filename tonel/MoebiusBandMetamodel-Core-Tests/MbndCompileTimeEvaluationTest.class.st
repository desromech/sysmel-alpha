Class {
	#name : #MbndCompileTimeEvaluationTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-Module'
}

{ #category : #running }
MbndCompileTimeEvaluationTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testAddInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #+) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 4
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testAddInteger2 [
	| ast result |
	ast := builder send: (builder literalSymbol: #+) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 4
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testLiteralInteger [
	| ast result |
	ast := builder literalInteger: 42.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]
