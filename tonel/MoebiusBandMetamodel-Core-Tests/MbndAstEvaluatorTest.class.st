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
		'visitor',
		'returnContext'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-Evaluation'
}

{ #category : #running }
MbndAstEvaluatorTest >> setUp [
	super setUp.
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	returnContext := MbndReturnContextScope empty.
	scope := MbndLexicalScope parent: returnContext.
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

{ #category : #running }
MbndAstEvaluatorTest >> testReturn [
	| node |
	node := builder return: (builder literalInteger: 42).
	[
		visitor visitNode: node
	] on: MbndEvaluationReturn do: [ :e |
		self assert: e targetReturnContext equals: returnContext.
		self assert: e returnValue unwrapMbndValue equals: 42
	].
	
]
