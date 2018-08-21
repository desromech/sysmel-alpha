Class {
	#name : #SYMLAPSGLexicalScopeNode,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'lexicalEnvironment',
		'node'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> analyzeAndEvaluateInEnvironment: environment [
	| innerScope |
	innerScope := environment newLexicalScope.
	^ node analyzeAndEvaluateInEnvironment: innerScope
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> evaluateInEnvironment: anEnvironment [
	| evaluationEnvironment |
	evaluationEnvironment := anEnvironment newLexicalScope.
	^ node evaluateInEnvironment: evaluationEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> evaluateTypeInEnvironment: anEnvironment [
	^ node evaluateTypeInEnvironment: lexicalEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> generateSSACodeWith: aBuilder [
	aBuilder withDebugPosition: self position do: [ 
		^ node generateSSACodeWith: aBuilder
	]
]

{ #category : #'as yet unclassified' }
SYMLAPSGLexicalScopeNode >> inlineBlockAnalyzeAndEvaluateInEnvironment: environment [
	^ node inlineBlockAnalyzeAndEvaluateInEnvironment: environment
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> isLexicalScopeNode [
	^ true
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> lexicalEnvironment [
	^ lexicalEnvironment
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> lexicalEnvironment: anObject [
	lexicalEnvironment := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> macroExpansionInEnvironment: anEnvironment [
	^ self shallowCopy
		node: (node macroExpansionInEnvironment: anEnvironment);
		yourself
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> node: anObject [
	node := anObject
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> pragmaAt: selector [
	^ node pragmaAt: selector
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> pragmaAt: selector ifAbsent: ifAbsentBlock [
	^ node pragmaAt: selector ifAbsent: ifAbsentBlock
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> pragmaAt: selector ifPresent: ifPresentBlock [
	^ node pragmaAt: selector ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> pragmaAt: selector ifPresent: ifPresentBlock ifAbsent: ifAbsentBlock [
	^ node pragmaAt: selector ifPresent: ifPresentBlock ifAbsent: ifAbsentBlock
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> semanticAnalysisInEnvironment: environment [
	| innerScope |
	innerScope := environment newLexicalScope.
	^ self copy
		lexicalEnvironment: innerScope;
		node: (node semanticAnalysisInEnvironment: innerScope);
		yourself
]
