Class {
	#name : #SYMLMacro,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #accessing }
SYMLMacro class >> module: aModule [
	^ self new module: aModule
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
