Class {
	#name : #SYMLFunctionVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'ssaValue'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #'as yet unclassified' }
SYMLFunctionVariable >> doCreateSSADebugInformation [
	^ (SLVMDebugVariable scope: nil name: self validName)
		type: self type ssaType;
		yourself
]

{ #category : #'code generation' }
SYMLFunctionVariable >> generateSSAReferenceWith: builder [
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionVariable >> isAnonymousGlobal: aBoolean [
	"This is ignored here."
]

{ #category : #testing }
SYMLFunctionVariable >> isSysmelIncompleteValueInEnvironment: environment [
	| currentBinding |
	currentBinding := environment lookSymbolRecursively: name ifAbsent: [ ^ false ].
	^ self == currentBinding
]

{ #category : #'as yet unclassified' }
SYMLFunctionVariable >> setupSSADebugInformationWith: builder [
	| debugVar varDeclaration convertedPosition |
	self module isEmittingDebugInformation ifTrue: [ 
		debugVar := self createSSADebugInformation.
		ssaValue debugInformation: debugVar.
	
		varDeclaration := builder debugSetVariable: debugVar value: ssaValue.
		
		definitionPosition ifNotNil: [
			convertedPosition := module convertDebugPosition: definitionPosition.
			ssaValue debugSourceLocation: convertedPosition.
			varDeclaration debugSourceLocation: convertedPosition.
		].
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
