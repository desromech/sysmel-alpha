Class {
	#name : #SYMLObjectAlias,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'value',
		'lazyValue',
		'hasEvaluatedValue'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLObjectAlias >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ self evaluatedValue analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment
]

{ #category : #definition }
SYMLObjectAlias >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	hasEvaluatedValue := false.
	lazyValue := bodyLazyValue.
	name ifNotNil: [ 
		parent addSymbol: name value: self.
	].
	
]

{ #category : #'as yet unclassified' }
SYMLObjectAlias >> evaluatedValue [
	hasEvaluatedValue ifFalse: [
		hasEvaluatedValue := true.
		value := lazyValue value
	].

	^ value
]

{ #category : #initialization }
SYMLObjectAlias >> initialize [
	super initialize.
	hasEvaluatedValue := false
	
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
