Class {
	#name : #SYMLFunctionVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'ssaValue'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'code generation' }
SYMLFunctionVariable >> generateSSAReferenceWith: builder [
	^ ssaValue
]

{ #category : #testing }
SYMLFunctionVariable >> isSysmelIncompleteValueInEnvironment: environment [
	| currentBinding |
	currentBinding := environment lookSymbolRecursively: name ifAbsent: [ ^ false ].
	^ self == currentBinding
]

{ #category : #'as yet unclassified' }
SYMLFunctionVariable >> setupSSADebugInformation [
	| debugVar |
	self module isEmittingDebugInformation ifTrue: [ 
		debugVar := SLVMDebugVariable scope: nil name: self validName.
		ssaValue debugInformation: debugVar.
	].

]

{ #category : #accessing }
SYMLFunctionVariable >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionVariable >> ssaValue: anObject [
	ssaValue := anObject
]
