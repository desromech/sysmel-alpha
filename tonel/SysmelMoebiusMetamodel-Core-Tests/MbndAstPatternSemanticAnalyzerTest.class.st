Class {
	#name : #MbndAstPatternSemanticAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'scope',
		'visitor',
		'compilationTarget'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-SemanticAnalysis'
}

{ #category : #running }
MbndAstPatternSemanticAnalyzerTest >> setUp [
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
	builder := MbndAstBuilder forModule: module.
	scope := module newGenericAnalysisScope.
	visitor := MbndAstSemanticAnalyzer new
		scope: scope;
		module: module
]

{ #category : #tests }
MbndAstPatternSemanticAnalyzerTest >> testLetPattern [

	| node pattern |
	node := builder unexpandedSend: (builder literalSymbol: #x) to: (builder identifier: #let) withArguments: #().
	pattern := visitor analyzePatternMatchingPatternNode: node withValueOfType: compilationTarget int32Type.
	self assert: pattern isPatternMatchingBindingPatternNode.
	self assert: pattern name equals: #x.
	self assert: pattern value equals: nil.
	self assert: pattern type equals: compilationTarget int32Type.
	self assert: pattern binding isNotNil.
	self assert: pattern collectBindings equals: {pattern}.
]

{ #category : #tests }
MbndAstPatternSemanticAnalyzerTest >> testLiteralIntegerPattern [

	| node pattern |
	node := builder literalInteger: 42.
	pattern := visitor analyzePatternMatchingPatternNode: node withValueOfType: compilationTarget int32Type.
	self assert: pattern isPatternMatchingLiteralValuePatternNode.
	self assert: pattern value equals: 42.
	self assert: pattern type equals: compilationTarget int32Type.
	self assert: pattern collectBindings equals: #().
]
