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
	| innerScope result |
	innerScope := environment newLexicalScope.
	result := node analyzeAndEvaluateInEnvironment: innerScope.
	innerScope cleanUpActions do: [ :action |
		self halt
	].
	
	^ result
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> evaluateInEnvironment: anEnvironment [
	| evaluationEnvironment result |
	evaluationEnvironment := anEnvironment newLexicalScope.
	result := node evaluateInEnvironment: evaluationEnvironment.
	lexicalEnvironment cleanUpActions do: [ :cleanUpAction |
		self halt.
	].
	
	^ result
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> evaluateTypeInEnvironment: anEnvironment [
	^ node evaluateTypeInEnvironment: lexicalEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGLexicalScopeNode >> generateSSACodeWith: aBuilder [
	| result |
	aBuilder withDebugPosition: self position do: [ 
		result := node generateSSACodeWith: aBuilder.
		aBuilder isLastTerminator ifTrue: [ ^ result ].
		lexicalEnvironment generateSSACleanUpActionsWith: aBuilder.
		
		^ result
	].
]

{ #category : #accessing }
SYMLAPSGLexicalScopeNode >> hasPragmaNamed: selector [
	^ node hasPragmaNamed: selector
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
