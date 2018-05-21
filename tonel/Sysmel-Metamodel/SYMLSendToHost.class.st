Class {
	#name : #SYMLSendToHost,
	#superclass : #SYMLMacro,
	#classVars : [
		'SelectorMap'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #initialization }
SYMLSendToHost class >> initialize [
	SelectorMap := Dictionary newFromPairs: #(
		#'prefix--' negated
	)
	
]

{ #category : #'macro compilation' }
SYMLSendToHost >> evaluateLiteralMessage: message inEnvironment: environment at: aPosition [
	| receiver arguments selector |
	selector := self mapSelector: message selector.
	receiver := (message receiver evaluateInEnvironment: environment) unwrapSysmelValue.
	arguments := message arguments collect: [ :arg | (arg evaluateInEnvironment: environment) unwrapSysmelValue ].
	^ ((receiver perform: selector withArguments: arguments)
		asSysmelValueInEnvironment: environment)
		asAPSGNodeInEnvironment: environment at: aPosition
]

{ #category : #'macro compilation' }
SYMLSendToHost >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver arguments |
	receiver := (message receiver evaluateInEnvironment: anEnvironment) unwrapSysmelValue .
	arguments := message arguments collect: [ :arg | (arg evaluateInEnvironment: anEnvironment) unwrapSysmelValue ].
	^ (receiver perform: message selector withArguments: arguments) asSysmelValueInEnvironment: anEnvironment
]

{ #category : #'macro compilation' }
SYMLSendToHost >> mapSelector: selector [
	^ SelectorMap at: selector ifAbsent: [ selector ]
]

{ #category : #'macro compilation' }
SYMLSendToHost >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| withAnalyzedArguments |
	withAnalyzedArguments := message analyzeArgumentsInEnvironment: environment.
	withAnalyzedArguments isLiteralMessage ifTrue: [ 
		^ self evaluateLiteralMessage: withAnalyzedArguments inEnvironment: environment at: aPosition
	].
	^ withAnalyzedArguments
		selector: (self mapSelector: message selector);
		metaMethod: self;
		valueType: (environment compilationTarget compilerObjectType);
		yourself
]
