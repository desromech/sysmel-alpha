Class {
	#name : #SYMLFunctionArgument,
	#superclass : #SYMLFunctionVariable,
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #'as yet unclassified' }
SYMLFunctionArgument >> doCreateSSADebugInformation [
	^ super doCreateSSADebugInformation
		argumentIndex: ssaValue index;
		yourself
]
