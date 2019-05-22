Class {
	#name : #MbndTemplateDefinitionFragment,
	#superclass : #Object,
	#instVars : [
		'node',
		'scope'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #'semantic analysis' }
MbndTemplateDefinitionFragment >> applyToInstance: templateInstance [
	| evaluationScope |
	evaluationScope := templateInstance programEntityScope parent: scope.
	^ MbndAstSemanticAnalyzerAndEvaluator new
		module: templateInstance module;
		evaluateNode: node withReturnContextInScope: evaluationScope
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> node [
	^ node
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> node: anObject [
	node := anObject
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> scope [
	^ scope
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> scope: anObject [
	scope := anObject
]
