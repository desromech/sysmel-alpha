Class {
	#name : #SYMLAPSGPragma,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGPragma >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLAPSGPragma >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLAPSGPragma >> selector [
	^ selector
]

{ #category : #accessing }
SYMLAPSGPragma >> selector: anObject [
	selector := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGPragma >> semanticAnalysisInEnvironment: environment [
	^ SYMLAPSGLiteralPragma new
		position: position;
		selector: selector;
		arguments: (arguments collect: [ :arg | arg analyzeAndEvaluateInEnvironment: environment ]);
		yourself
]
