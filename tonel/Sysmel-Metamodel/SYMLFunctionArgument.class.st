Class {
	#name : #SYMLFunctionArgument,
	#superclass : #SYMLFunctionVariable,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLFunctionArgument >> doCreateSSADebugInformation [
	^ super doCreateSSADebugInformation
		argumentIndex: ssaValue index;
		yourself
]
