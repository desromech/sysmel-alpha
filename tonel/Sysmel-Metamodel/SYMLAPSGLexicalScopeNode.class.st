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

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> lexicalEnvironment [
	^ lexicalEnvironment
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> lexicalEnvironment: anObject [
	lexicalEnvironment := anObject
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> node: anObject [
	node := anObject
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
