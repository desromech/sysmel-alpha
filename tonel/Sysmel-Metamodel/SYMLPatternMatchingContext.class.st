Class {
	#name : #SYMLPatternMatchingContext,
	#superclass : #SYMLObject,
	#instVars : [
		'template',
		'matchedArguments'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'instance creation' }
SYMLPatternMatchingContext class >> for: aTemplate [
	^ self new initializeFor: aTemplate
]

{ #category : #initialization }
SYMLPatternMatchingContext >> initializeFor: aTemplate [
	template := aTemplate.
	matchedArguments := (Array new: aTemplate templateArguments size).
	
]

{ #category : #testing }
SYMLPatternMatchingContext >> isAllMatched [
	^ matchedArguments detect: #isNil ifFound: [ false ] ifNone: [ true ]
]

{ #category : #'as yet unclassified' }
SYMLPatternMatchingContext >> matchIncompleteValue: incompleteValue with: suppliedValue at: position [
	| argumentIndex binding |
	binding := incompleteValue binding.
	argumentIndex := template templateArguments indexOf: binding.
	^ (matchedArguments at: argumentIndex) ifNil: [
		(suppliedValue type isSysmelKindOf: binding type) ifTrue: [ 
			matchedArguments at: argumentIndex put: suppliedValue.
			^ suppliedValue
		] ifFalse: [ 
			^ nil
		]
	] ifNotNil: [ :previousMatch |
		previousMatch matchValue: suppliedValue withMatchingContext: self at: position
	].	
]

{ #category : #accessing }
SYMLPatternMatchingContext >> matchedArguments [
	^ matchedArguments
]

{ #category : #copying }
SYMLPatternMatchingContext >> postCopy [
	super postCopy.
	matchedArguments := matchedArguments copy
]

{ #category : #accessing }
SYMLPatternMatchingContext >> template [
	^ template
]
