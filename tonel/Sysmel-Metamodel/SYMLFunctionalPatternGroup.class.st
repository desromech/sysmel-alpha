Class {
	#name : #SYMLFunctionalPatternGroup,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'alternatives',
		'fallbackPattern'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #adding }
SYMLFunctionalPatternGroup >> addPatternAlternative: aPatternAlternative [
	alternatives := alternatives copyWith: aPatternAlternative.
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> fallbackPattern [
	^ fallbackPattern
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> fallbackPattern: anObject [
	fallbackPattern := anObject
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findPatternForMessage: message inEnvironment: environment at: aPosition [
	"Handle quickly the case without alternatives"
	alternatives ifEmpty: [ ^ {message . fallbackPattern} ].
	(fallbackPattern isNil and: [ alternatives size = 1 ]) ifTrue: [ ^ {message . alternatives first} ].
	
	self halt
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findPatternWithArgumentTypes: argumentTypes [
	"Handle quickly the case without alternatives"
	alternatives ifEmpty: [ ^ fallbackPattern ].
	(fallbackPattern isNil and: [ alternatives size = 1 ]) ifTrue: [ ^ alternatives first ].
	
	self halt
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findValidPatternForMessage: message inEnvironment: environment at: aPosition [
	| messageAndPattern |
	messageAndPattern := self findPatternForMessage: message inEnvironment: environment at: aPosition.
	messageAndPattern ifNil: [
		^ self error: 'Cannot find matching alternative of {1}.' format: { name printString } at: aPosition
	].

	^ messageAndPattern
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findValidPatternWithArgumentTypes: argumentTypes at: aPosition [
	| pattern |
	pattern := self findPatternWithArgumentTypes: argumentTypes.
	pattern ifNil: [
		^ self error: 'Cannot find matching alternative of {1}.' format: { name printString } at: aPosition
	].

	^ pattern
]

{ #category : #initialization }
SYMLFunctionalPatternGroup >> initialize [
	super initialize.
	alternatives := #().
]

{ #category : #testing }
SYMLFunctionalPatternGroup >> isMacroPatternGroup [
	^ true
]
