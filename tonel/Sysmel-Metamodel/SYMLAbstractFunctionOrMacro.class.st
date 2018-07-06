Class {
	#name : #SYMLAbstractFunctionOrMacro,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'macro compilation' }
SYMLAbstractFunctionOrMacro >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	^ (self semanticAnalyzeMessage: message inEnvironment: environment at: aPosition) evaluateInEnvironment: environment
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionOrMacro >> createReceiverTypeForParent [

]

{ #category : #testing }
SYMLAbstractFunctionOrMacro >> isTemplateFunctionInstance [
	^ false
]

{ #category : #accessing }
SYMLAbstractFunctionOrMacro >> parent: aParent [
	super parent: aParent.
	aParent ifNotNil: [ self createReceiverTypeForParent ].
]

{ #category : #accessing }
SYMLAbstractFunctionOrMacro >> receiver [
	^ nil
]
