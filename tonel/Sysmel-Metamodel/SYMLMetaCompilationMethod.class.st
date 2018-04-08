Class {
	#name : #SYMLMetaCompilationMethod,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-MetaCompilationMethod'
}

{ #category : #accessing }
SYMLMetaCompilationMethod class >> module: aModule [
	^ self new module: aModule
]

{ #category : #'as yet unclassified' }
SYMLMetaCompilationMethod >> evaluateMessage: message inEnvironment: anEnvironment [
	self subclassResponsibility
]

{ #category : #testing }
SYMLMetaCompilationMethod >> isMetaMethod [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLMetaCompilationMethod >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	self subclassResponsibility
]
