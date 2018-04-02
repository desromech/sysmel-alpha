Class {
	#name : #SYMLAPSGTupleWithType,
	#superclass : #SYMLAPSGTuple,
	#instVars : [
		'type'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGTupleWithType >> evaluateInEnvironment: anEnvironment [
	^ (elements collect: [ :el | el evaluateInEnvironment: anEnvironment ]) sysmelValueWithType: type inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLAPSGTupleWithType >> evaluateTypeInEnvironment: anEnvironment [
	^ type
]

{ #category : #accessing }
SYMLAPSGTupleWithType >> type [
	^ type
]

{ #category : #accessing }
SYMLAPSGTupleWithType >> type: anObject [
	type := anObject
]
