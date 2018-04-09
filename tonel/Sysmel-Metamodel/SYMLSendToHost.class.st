Class {
	#name : #SYMLSendToHost,
	#superclass : #SYMLMacro,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLSendToHost >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver arguments |
	receiver := (message receiver evaluateInEnvironment: anEnvironment) unwrapSysmelValue .
	arguments := message arguments collect: [ :arg | (arg evaluateInEnvironment: anEnvironment) unwrapSysmelValue ].
	^ (receiver perform: message selector withArguments: arguments) asSysmelValueInEnvironment: anEnvironment
]

{ #category : #'macro compilation' }
SYMLSendToHost >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ (message analyzeArgumentsInEnvironment: environment)
		metaMethod: self;
		valueType: environment compilationTarget compilerObjectType;
		yourself
]
