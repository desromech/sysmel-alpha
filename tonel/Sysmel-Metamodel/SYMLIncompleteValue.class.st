Class {
	#name : #SYMLIncompleteValue,
	#superclass : #SYMLAbstractValue,
	#instVars : [
		'binding',
		'type'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #accessing }
SYMLIncompleteValue >> binding [
	^ binding
]

{ #category : #accessing }
SYMLIncompleteValue >> binding: anObject [
	binding := anObject
]

{ #category : #'as yet unclassified' }
SYMLIncompleteValue >> concretizeInEnvironment: concreteEnvironment [
	^ binding concretizeIncompleteValue: self inEnvironment: concreteEnvironment
]

{ #category : #testing }
SYMLIncompleteValue >> isSysmelIncompleteValue [
	^ true
]

{ #category : #'pattern matching' }
SYMLIncompleteValue >> matchValue: suppliedValue withMatchingContext: patternMatchingContext at: position [
	^ patternMatchingContext matchIncompleteValue: self with: suppliedValue at: position
]

{ #category : #'as yet unclassified' }
SYMLIncompleteValue >> sameValueButWithType: aNewType [
	^ self copy type: aNewType
]

{ #category : #'as yet unclassified' }
SYMLIncompleteValue >> sysmelMangledValue [
	<compileTime>
	^ #u
]

{ #category : #accessing }
SYMLIncompleteValue >> type [
	^ type
]

{ #category : #accessing }
SYMLIncompleteValue >> type: anObject [
	type := anObject
]
