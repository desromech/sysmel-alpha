Class {
	#name : #SYMLAbstractFunctionOrMacro,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #adding }
SYMLAbstractFunctionOrMacro >> addAllAlternativesWithPublicSelector: publicSelector into: methodCollection [
	self messageSendSelector ifNotNil: [ :selector |
		methodCollection add: selector -> self.
		selector ~= publicSelector ifTrue: [ 
			methodCollection add: (publicSelector -> self)
		].
	] ifNil: [
		methodCollection add: (publicSelector -> self)
	].

]

{ #category : #'macro compilation' }
SYMLAbstractFunctionOrMacro >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	^ (self semanticAnalyzeMessage: message inEnvironment: environment at: aPosition) evaluateInEnvironment: environment
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionOrMacro >> createReceiverTypeForParent [

]

{ #category : #'virtual methods' }
SYMLAbstractFunctionOrMacro >> isMatchedByOverridingMethod: derivedMethod [
	^ false
]

{ #category : #testing }
SYMLAbstractFunctionOrMacro >> isOverride [
	^ false
]

{ #category : #testing }
SYMLAbstractFunctionOrMacro >> isTemplateFunctionInstance [
	^ false
]

{ #category : #testing }
SYMLAbstractFunctionOrMacro >> isVirtual [
	^ false
]

{ #category : #accessing }
SYMLAbstractFunctionOrMacro >> messageSendSelector [
	^ name
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

{ #category : #accessing }
SYMLAbstractFunctionOrMacro >> receiverType [
	^ self compilationTarget voidType
]
