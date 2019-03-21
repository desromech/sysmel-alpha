"
A MbndAstSemanticAnalyzerTest is a test class for testing the behavior of MbndAstSemanticAnalyzer
"
Class {
	#name : #MbndAstSemanticAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'scope',
		'visitor'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-SemanticAnalysis'
}

{ #category : #running }
MbndAstSemanticAnalyzerTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	scope := MbndLexicalScope empty.
	visitor := MbndAstSemanticAnalyzer new scope: scope.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteral [
	| literal analyzedNode |
	literal := builder literalInteger: 42.
	analyzedNode := visitor visitNode: literal.
	self assert: analyzedNode equals: literal
]

{ #category : #running }
MbndAstSemanticAnalyzerTest >> testNew [
	self assert: visitor scope equals: scope
]
