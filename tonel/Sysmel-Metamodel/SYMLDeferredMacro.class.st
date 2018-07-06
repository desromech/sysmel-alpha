Class {
	#name : #SYMLDeferredMacro,
	#superclass : #SYMLMacro,
	#traits : 'TSYMLInterpretedCompilationObject',
	#classTraits : 'TSYMLInterpretedCompilationObject classTrait',
	#instVars : [
		'analysisAndEvaluation',
		'evaluation',
		'semanticAnalysis',
		'codeGeneration',
		'metaMessageAnalysis'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #accessing }
SYMLDeferredMacro >> analysisAndEvaluation [
	^ analysisAndEvaluation
]

{ #category : #accessing }
SYMLDeferredMacro >> analysisAndEvaluation: anObject [
	analysisAndEvaluation := anObject
]

{ #category : #'macro compilation' }
SYMLDeferredMacro >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	analysisAndEvaluation ifNil: [ ^ super analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition ].
	^ analysisAndEvaluation valueWithReceiver: self arguments: { message . environment . aPosition}
]

{ #category : #'as yet unclassified' }
SYMLDeferredMacro >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	^ metaMessageAnalysis  valueWithReceiver: self arguments: { message . receiverValue . environment . aPosition}
]

{ #category : #accessing }
SYMLDeferredMacro >> codeGeneration [
	^ codeGeneration
]

{ #category : #accessing }
SYMLDeferredMacro >> codeGeneration: anObject [
	codeGeneration := anObject
]

{ #category : #'macro compilation' }
SYMLDeferredMacro >> evaluateMessage: message inEnvironment: anEnvironment [
	^ evaluation valueWithReceiver: self arguments: { message . anEnvironment}
]

{ #category : #accessing }
SYMLDeferredMacro >> evaluation [
	^ evaluation
]

{ #category : #accessing }
SYMLDeferredMacro >> evaluation: anObject [
	evaluation := anObject
]

{ #category : #'macro compilation' }
SYMLDeferredMacro >> generateMessage: messageNode ssaCodeWith: builder [
	^ codeGeneration valueWithReceiver: self arguments: { messageNode . builder }
]

{ #category : #accessing }
SYMLDeferredMacro >> metaMessageAnalysis [
	^ metaMessageAnalysis
]

{ #category : #accessing }
SYMLDeferredMacro >> metaMessageAnalysis: anObject [
	metaMessageAnalysis := anObject
]

{ #category : #accessing }
SYMLDeferredMacro >> semanticAnalysis [
	^ semanticAnalysis
]

{ #category : #accessing }
SYMLDeferredMacro >> semanticAnalysis: anObject [
	semanticAnalysis := anObject
]

{ #category : #'macro compilation' }
SYMLDeferredMacro >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ semanticAnalysis valueWithReceiver: self arguments: { message . environment . aPosition}
]
