"
A MbndAstSemanticAnalyzerAndEvaluatorTest is a test class for testing the behavior of MbndAstSemanticAnalyzerAndEvaluator
"
Class {
	#name : #MbndAstSemanticAnalyzerAndEvaluatorTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-Evaluation'
}

{ #category : #tests }
MbndAstSemanticAnalyzerAndEvaluatorTest >> testNew [
	| visitor |
	visitor := MbndAstSemanticAnalyzerAndEvaluator new.
	self assert: visitor semanticAnalyzer isNotNil.
	self assert: visitor evaluator isNotNil.
]

{ #category : #tests }
MbndAstSemanticAnalyzerAndEvaluatorTest >> testSetScope [
	| visitor scope |
	scope := MbndLexicalScope empty.
	visitor := MbndAstSemanticAnalyzerAndEvaluator new.
	visitor scope: scope.
	
	self assert: visitor semanticAnalyzer scope equals: scope.
	self assert: visitor evaluator scope equals: scope.
]
