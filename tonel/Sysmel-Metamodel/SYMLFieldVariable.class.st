Class {
	#name : #SYMLFieldVariable,
	#superclass : #SYMLAbstractVariable,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLFieldVariable >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ aNode
]

{ #category : #'as yet unclassified' }
SYMLFieldVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			definitionEnvironment addFieldVariable: self at: aPosition.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]
