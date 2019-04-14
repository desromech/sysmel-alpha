Class {
	#name : #MbndCompilationError,
	#superclass : #Error,
	#instVars : [
		'sourcePosition'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Exceptions'
}

{ #category : #accessing }
MbndCompilationError >> description [
	"Return a textual description of the exception."

	^ String streamContents: [ :stream |
		sourcePosition sourceTextPosition ifNotNil: [ :position | position printOn: stream ].
		stream nextPutAll: ': '; nextPutAll: self messageText
	]
]

{ #category : #accessing }
MbndCompilationError >> sourcePosition [
	^ sourcePosition
]

{ #category : #accessing }
MbndCompilationError >> sourcePosition: anObject [
	sourcePosition := anObject
]
