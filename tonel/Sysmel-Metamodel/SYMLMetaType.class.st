Class {
	#name : #SYMLMetaType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'instanceType'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #testing }
SYMLMetaType >> canBeCoercedImplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ true ].
	^ super canBeCoercedImplicitlyInto: targetType
]

{ #category : #accessing }
SYMLMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
SYMLMetaType >> instanceType: anObject [
	instanceType := anObject
]

{ #category : #testing }
SYMLMetaType >> isMetaType [
	^ true
]

{ #category : #printing }
SYMLMetaType >> printOn: aStream [
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'
]

{ #category : #printing }
SYMLMetaType >> type [
	^ self compilationTarget metaType
]
