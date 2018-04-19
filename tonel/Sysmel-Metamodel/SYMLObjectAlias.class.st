Class {
	#name : #SYMLObjectAlias,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLObjectAlias >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ value analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment
]

{ #category : #definition }
SYMLObjectAlias >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	value := bodyLazyValue value.
	name ifNotNil: [ 
		parent addSymbol: name value: self.
	].
	
]

{ #category : #'as yet unclassified' }
SYMLObjectAlias >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLObjectAlias >> tryToAddToParentWithName: aNewName [

]
