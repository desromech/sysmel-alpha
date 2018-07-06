Class {
	#name : #SYMLAPSGQuote,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'node'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'as yet unclassified' }
SYMLAPSGQuote >> evaluateInEnvironment: anEnvironment [
	^ anEnvironment wrapAPSGNode: node
]

{ #category : #'meta evaluation' }
SYMLAPSGQuote >> evaluateTypeInEnvironment: anEnvironment [
	^ anEnvironment compilationTarget apsgNodeType
]

{ #category : #'as yet unclassified' }
SYMLAPSGQuote >> inlineBlockAnalyzeAndEvaluateInEnvironment: environment [
	| evaluationEnvironment |
	evaluationEnvironment := environment newLexicalScope.
	^ node analyzeAndEvaluateInEnvironment: evaluationEnvironment
]

{ #category : #'as yet unclassified' }
SYMLAPSGQuote >> inlineBlockSemanticAnalysisInEnvironment: environment [
	^ (SYMLAPSGLexicalScopeNode new
		position: self;
		node: node;
		yourself) semanticAnalysisInEnvironment: environment
	
]

{ #category : #'meta evaluation' }
SYMLAPSGQuote >> inlineSemanticAnalysisInEnvironment: anEnvironment [
	^ node semanticAnalysisInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGQuote >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGQuote >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGQuote >> node: anObject [
	node := anObject
]

{ #category : #copying }
SYMLAPSGQuote >> postCopy [
	node := node copy.
]

{ #category : #'meta evaluation' }
SYMLAPSGQuote >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]
