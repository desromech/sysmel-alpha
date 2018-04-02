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
SYMLAPSGQuote >> inlineBlockSemanticAnalysisInEnvironment: environment [
	^ node semanticAnalysisInEnvironment: environment
	
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
