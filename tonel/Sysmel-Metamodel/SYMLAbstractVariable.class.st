Class {
	#name : #SYMLAbstractVariable,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'type'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ identifier copyWithBinding: self andType: type
]

{ #category : #converting }
SYMLAbstractVariable >> asIncompleteValue [
	^ SYMLIncompleteValue new
		type: type;
		binding: self;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> concretizeIncompleteValue: value inEnvironment: concreteEnvironment [
	^ concreteEnvironment lookSymbolRecursively: name ifAbsent: [ self error ]
]

{ #category : #accessing }
SYMLAbstractVariable >> name [
	^ name
]

{ #category : #accessing }
SYMLAbstractVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLAbstractVariable >> type [
	^ type
]

{ #category : #accessing }
SYMLAbstractVariable >> type: anObject [
	type := anObject
]
