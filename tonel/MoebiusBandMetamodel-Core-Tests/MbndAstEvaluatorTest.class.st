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
		'visitor'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-Evaluation'
}

{ #category : #running }
MbndAstEvaluatorTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	scope := MbndLexicalScope empty.
	visitor := MbndAstEvaluator new scope: scope.
]

{ #category : #running }
MbndAstEvaluatorTest >> testLiteral [
	| literal value |
	literal := builder literalInteger: 42.
	value := visitor visitNode: literal.
	self assert: value unwrapMbndValue equals: 42
]

{ #category : #running }
MbndAstEvaluatorTest >> testNew [
	self assert: visitor scope equals: scope
]
