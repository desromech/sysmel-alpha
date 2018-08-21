Class {
	#name : #SYMLAPSGQuasiQuote,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'node'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGQuasiQuote >> evaluateInEnvironment: anEnvironment [
	^ anEnvironment wrapAPSGNode: (node macroExpansionInEnvironment: anEnvironment)
]

{ #category : #testing }
SYMLAPSGQuasiQuote >> isQuasiQuote [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiQuote >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGQuasiQuote >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGQuasiQuote >> node: anObject [
	node := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiQuote >> postCopy [
	node := node copy.
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiQuote >> semanticAnalysisInEnvironment: environment [
	^ self shallowCopy
		node: (node macroSemanticAnalysisInEnvironment: environment);
		yourself
]
