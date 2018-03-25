Class {
	#name : #SYMLLazyMessageSendMetaMethod,
	#superclass : #SYMLMessageSendMetaMethod,
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #'meta methods' }
SYMLLazyMessageSendMetaMethod >> evaluateMessage: messageNode inEnvironment: anEnvironment [
	| receiver arguments |
	receiver := messageNode receiver evaluateInEnvironment: anEnvironment.
	arguments := anEnvironment wrapAPSGNodes: messageNode arguments.
	^ (receiver value perform: messageNode selector withArguments: arguments) asSysmelValueInEnvironment: anEnvironment
]
