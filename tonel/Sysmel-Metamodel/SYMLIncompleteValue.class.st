Class {
	#name : #SYMLIncompleteValue,
	#superclass : #SYMLObject,
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
SYMLIncompleteValue >> isIncompleteValue [
	^ true
]

{ #category : #testing }
SYMLIncompleteValue >> isSysmelIncompleteValue [
	^ true
]

{ #category : #accessing }
SYMLIncompleteValue >> type [
	^ type
]

{ #category : #accessing }
SYMLIncompleteValue >> type: anObject [
	type := anObject
]
