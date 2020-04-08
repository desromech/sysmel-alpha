Class {
	#name : #MbndSimultaneousTypeConcept,
	#superclass : #MbndTypeConcept,
	#instVars : [
		'components'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSimultaneousTypeConcept class >> typeName [
	^ #_UnionTypeConcept
]

{ #category : #'logical operations' }
MbndSimultaneousTypeConcept >> & otherType [
	<compileTime>
	^ self compilationTarget simultanousTypeConcepts: components , { otherType }
]

{ #category : #accessing }
MbndSimultaneousTypeConcept >> components [
	^ components
]

{ #category : #accessing }
MbndSimultaneousTypeConcept >> components: anObject [
	components := anObject
]

{ #category : #'as yet unclassified' }
MbndSimultaneousTypeConcept >> doesTypeComplyWithConcept: aType [
	<compileTime>
	^ components allSatisfy: [ :each | each doesTypeComplyWithConcept: aType ]
]

{ #category : #testing }
MbndSimultaneousTypeConcept >> isSimultaneousTypeConcept [
	^ true
]
