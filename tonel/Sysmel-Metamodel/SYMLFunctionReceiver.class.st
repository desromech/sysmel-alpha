Class {
	#name : #SYMLFunctionReceiver,
	#superclass : #SYMLFunctionVariable,
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #'as yet unclassified' }
SYMLFunctionReceiver >> doCreateSSADebugInformation [
	^ super doCreateSSADebugInformation
		argumentIndex: ssaValue index;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLFunctionReceiver >> evaluateBindingInEnvironment: environment [
	^ environment lookReceiverValueFor: self
]
