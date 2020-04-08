Class {
	#name : #MbndPredicatedTypeConcept,
	#superclass : #MbndTypeConcept,
	#instVars : [
		'predicate'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPredicatedTypeConcept class >> typeName [
	^ #_PredicatedTypeConcept
]

{ #category : #visiting }
MbndPredicatedTypeConcept >> accept: aVisitor [
	^ aVisitor visitPredicatedTypeConcept: self
]

{ #category : #'as yet unclassified' }
MbndPredicatedTypeConcept >> doesTypeComplyWithConcept: aType [
	<compileTime>
	| result |
	result := (predicate valueWithArguments: { aType }) unwrapMbndValue.
	result == true ifTrue: [ ^ true ].
	result == false ifTrue: [ ^ false ].
	self error: 'Predicated type concept did not return a boolean value.'
]

{ #category : #testing }
MbndPredicatedTypeConcept >> isPredicatedTypeConcept [
	^ true
]

{ #category : #accessing }
MbndPredicatedTypeConcept >> predicate [
	^ predicate
]

{ #category : #accessing }
MbndPredicatedTypeConcept >> predicate: anObject [
	predicate := anObject
]
