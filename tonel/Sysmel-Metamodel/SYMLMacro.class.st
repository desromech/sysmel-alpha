Class {
	#name : #SYMLMacro,
	#superclass : #SYMLAbstractFunctionOrMacro,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #accessing }
SYMLMacro class >> module: aModule [
	^ self new module: aModule
]

{ #category : #adding }
SYMLMacro >> addToPatternGroup: patternGroup [
	patternGroup fallbackPattern ifNotNil: [ 
		self error: 'Cannot add conflicting macro {1}.' format: { self name printString } at: self definitionPosition
	].

	patternGroup fallbackPattern: self
]

{ #category : #'macro compilation' }
SYMLMacro >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	self subclassResponsibility
]

{ #category : #'macro compilation' }
SYMLMacro >> evaluateMessage: message inEnvironment: anEnvironment [
	self subclassResponsibility
]

{ #category : #'macro compilation' }
SYMLMacro >> generateMessage: messageNode ssaCodeWith: builder [
	self subclassResponsibility
]

{ #category : #testing }
SYMLMacro >> isMetaMethod [
	^ true
]

{ #category : #'macro compilation' }
SYMLMacro >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLMacro >> tryToAddToParentWithName: aNewName [
	parent addMacroMethodPattern: self withSelector: aNewName
]
