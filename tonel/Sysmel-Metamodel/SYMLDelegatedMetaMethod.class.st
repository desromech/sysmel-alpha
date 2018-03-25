Class {
	#name : #SYMLDelegatedMetaMethod,
	#superclass : #SYMLMetaMethod,
	#instVars : [
		'evaluationFunction',
		'semanticAnalysisFunction',
		'codeGenerationFunction'
	],
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #'meta methods' }
SYMLDelegatedMetaMethod >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ semanticAnalysisFunction valueWithReceiver: self arguments: { messageNode . anEnvironment . aSourcePosition}
]

{ #category : #accessing }
SYMLDelegatedMetaMethod >> codeGenerationFunction [
	^ codeGenerationFunction
]

{ #category : #accessing }
SYMLDelegatedMetaMethod >> codeGenerationFunction: anObject [
	codeGenerationFunction := anObject
]

{ #category : #'meta methods' }
SYMLDelegatedMetaMethod >> evaluateMessage: messageNode inEnvironment: anEnvironment [
	^ evaluationFunction valueWithReceiver: self arguments: { messageNode . anEnvironment} 
]

{ #category : #accessing }
SYMLDelegatedMetaMethod >> evaluationFunction [
	^ evaluationFunction
]

{ #category : #accessing }
SYMLDelegatedMetaMethod >> evaluationFunction: anObject [
	evaluationFunction := anObject
]

{ #category : #'meta methods' }
SYMLDelegatedMetaMethod >> generateMessage: messageNode ssaCodeWith: builder [
	^ codeGenerationFunction valueWithReceiver: self arguments: { messageNode . builder}
]

{ #category : #parsing }
SYMLDelegatedMetaMethod >> install: function for: selector [
	selector == #evaluation: ifTrue: [ evaluationFunction := function . ^ self ].
	selector == #semanticAnalysis: ifTrue: [ semanticAnalysisFunction := function . ^ self ].
	selector == #codeGeneration: ifTrue: [ codeGenerationFunction := function . ^ self ].
	self error: 'Unsupported meta method action'
	
]

{ #category : #parsing }
SYMLDelegatedMetaMethod >> parseAction: action inEnvironment: environment [
	| actionFunction |
	(action isImplicitContextMessageNode and: [action arguments size = 1]) ifFalse: [
		self error: 'Expected an selector for the action name' at: action
	].

	actionFunction := action arguments first analyzeAndEvaluateInEnvironment: environment.
	self install: actionFunction value asSysmelCompileTimeFunction for: action selector
]

{ #category : #parsing }
SYMLDelegatedMetaMethod >> parseActions: actions inEnvironment: environment [
	actions type isAPSGNode ifFalse: [ self error: 'Expected an APSG node for the meta method actions.' ].
	actions value isSequenceNode ifFalse: [ self error: 'Expected a sequence of actions.' at: actions value ].
	actions value do: [ :action | self parseAction: action inEnvironment: environment ].
]

{ #category : #accessing }
SYMLDelegatedMetaMethod >> semanticAnalysisFunction [
	^ semanticAnalysisFunction
]

{ #category : #accessing }
SYMLDelegatedMetaMethod >> semanticAnalysisFunction: anObject [
	semanticAnalysisFunction := anObject
]
