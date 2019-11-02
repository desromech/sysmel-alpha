Class {
	#name : #MbndCompilationWarning,
	#superclass : #Warning,
	#instVars : [
		'sourcePosition'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Exceptions'
}

{ #category : #accessing }
MbndCompilationWarning >> description [
	"Return a textual description of the exception."

	^ String streamContents: [ :stream |
		sourcePosition sourceTextPosition ifNotNil: [ :position | position printOn: stream ].
		stream nextPutAll: ': Warning: '; nextPutAll: self messageText
	]
]

{ #category : #accessing }
MbndCompilationWarning >> sourcePosition [
	^ sourcePosition
]

{ #category : #accessing }
MbndCompilationWarning >> sourcePosition: anObject [
	sourcePosition := anObject
]
