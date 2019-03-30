Class {
	#name : #MbndAstSemanticAnalyzerAndEvaluator,
	#superclass : #MbndAstDelegationVisitor,
	#instVars : [
		'evaluator',
		'semanticAnalyzer'
	],
	#category : #'MoebiusBandMetamodel-Core-Evaluation'
}

{ #category : #delegate }
MbndAstSemanticAnalyzerAndEvaluator >> analyzeAndEvaluateNode: aNode [
	^ self evaluateNode: (self analyzeNode: aNode)
]

{ #category : #operations }
MbndAstSemanticAnalyzerAndEvaluator >> analyzeNode: aNode [
	^ semanticAnalyzer visitNode: aNode
]

{ #category : #delegate }
MbndAstSemanticAnalyzerAndEvaluator >> delegateNodeVisit: aNode [
	^ self analyzeAndEvaluateNode: aNode
]

{ #category : #operations }
MbndAstSemanticAnalyzerAndEvaluator >> evaluateNode: aNode [
	^ evaluator visitNode: aNode
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> evaluator [
	^ evaluator ifNil: [ evaluator := MbndAstEvaluator new ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> evaluator: anObject [
	evaluator := anObject
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> module: aModule [
	self semanticAnalyzer scope: aModule.
	self evaluator scope: aModule.
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> scope: aScope [
	self semanticAnalyzer scope: aScope.
	self evaluator scope: aScope.
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> semanticAnalyzer [
	^ semanticAnalyzer ifNil: [ semanticAnalyzer := MbndAstSemanticAnalyzer new ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> semanticAnalyzer: anObject [
	semanticAnalyzer := anObject
]

{ #category : #delegate }
MbndAstSemanticAnalyzerAndEvaluator >> visitLexicalScopeNode: node [
	| newScope |
	newScope := evaluator scope newLexicalScope.
	^ self withScope: newScope do: [
		self visitNode: node expression
	]
]

{ #category : #delegate }
MbndAstSemanticAnalyzerAndEvaluator >> visitSequenceNode: aNode [
	| result |
	result := nil.
	aNode elements do: [ :element |
		result := self visitNode: element
	].

	^ result
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> withAnalysisScope: newAnalysisScope evaluationScope: newEvaluationScope do: aBlock [
	| oldAnalysisScope oldEvaluationScope |
	oldAnalysisScope := semanticAnalyzer scope.
	oldEvaluationScope := evaluator scope.

	semanticAnalyzer scope: newAnalysisScope.
	evaluator scope: newEvaluationScope.
	
	^ aBlock ensure: [ 
		semanticAnalyzer scope: oldAnalysisScope.
		evaluator scope: oldEvaluationScope
	]
]

{ #category : #accessing }
MbndAstSemanticAnalyzerAndEvaluator >> withScope: newScope do: aBlock [
	^ self withAnalysisScope: newScope evaluationScope: newScope do: aBlock
]
