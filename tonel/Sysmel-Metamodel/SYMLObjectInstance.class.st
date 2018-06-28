Class {
	#name : #SYMLObjectInstance,
	#superclass : #SYMLObject,
	#instVars : [
		'type'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLObjectInstance >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: type inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLObjectInstance >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ type
]

{ #category : #converting }
SYMLObjectInstance >> generateSSAReferenceWith: builder [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLObjectInstance >> type [
	^ type
]

{ #category : #accessing }
SYMLObjectInstance >> type: anObject [
	type := anObject
]
