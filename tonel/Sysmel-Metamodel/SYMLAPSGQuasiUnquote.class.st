Class {
	#name : #SYMLAPSGQuasiUnquote,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'node'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGQuasiUnquote >> analyzeAndEvaluateInEnvironment: anEnvironment [
	^ node analyzeAndEvaluateInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiUnquote >> evaluateInEnvironment: anEnvironment [
	^ node evaluateInEnvironment: anEnvironment
]

{ #category : #testing }
SYMLAPSGQuasiUnquote >> evaluateTypeInEnvironment: anEnvironment [
	^ anEnvironment compilationTarget apsgNodeType
]

{ #category : #testing }
SYMLAPSGQuasiUnquote >> isQuasiUnquote [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiUnquote >> macroExpansionInEnvironment: anEnvironment [
	^ node macroExpansionEvaluateInEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLAPSGQuasiUnquote >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGQuasiUnquote >> node: anObject [
	node := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiUnquote >> semanticAnalysisInEnvironment: anEnvironment [
	^ node semanticAnalysisInEnvironment: anEnvironment
]
