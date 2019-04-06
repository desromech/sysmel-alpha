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
	scope := MbndLexicalScope parent: (module programEntityScope parent: (MbndGenericMacroLanguageTopLevelScope for: module)).
	visitor := MbndAstSemanticAnalyzer new
		scope: scope;
		module: module
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

{ #category : #running }
MbndAstSemanticAnalyzerTest >> testReturnMacroExpansion [
	| value node analyzedNode |
	value := builder literalInteger: 42.
	node := builder unexpandedSend: (builder literalSymbol: #return:)
		to: nil withArguments: {value}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isReturnStatementNode.
	self assert: analyzedNode expression equals: value.
	self assert: analyzedNode type isReturnType.
]
