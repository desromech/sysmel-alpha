Class {
	#name : #SYMLSemanticError,
	#superclass : #SYMLError,
	#instVars : [
		'sourcePosition',
		'environment'
	],
	#category : #'Sysmel-Metamodel-Exceptions'
}

{ #category : #accessing }
SYMLSemanticError >> description [
	"Return a textual description of the exception."

	^ String streamContents: [ :stream |
		sourcePosition position ifNotNil: [ :position | position printOn: stream ].
		stream nextPutAll: ': '; nextPutAll: self messageText
	]
]

{ #category : #accessing }
SYMLSemanticError >> environment [
	^ environment
]

{ #category : #accessing }
SYMLSemanticError >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
SYMLSemanticError >> sourcePosition [
	^ sourcePosition
]

{ #category : #accessing }
SYMLSemanticError >> sourcePosition: anObject [
	sourcePosition := anObject
]
