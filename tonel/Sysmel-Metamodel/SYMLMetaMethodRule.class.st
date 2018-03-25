Class {
	#name : #SYMLMetaMethodRule,
	#superclass : #SYMLProgramEntity,
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #testing }
SYMLMetaMethodRule >> matchesMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	self subclassResponsibility
]
