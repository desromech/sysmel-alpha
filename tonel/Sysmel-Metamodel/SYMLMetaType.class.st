Class {
	#name : #SYMLMetaType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'instanceType'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLMetaType >> asReceiverType [
	^ self
]

{ #category : #testing }
SYMLMetaType >> coercedImplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super coercedImplicitlyInto: targetType targetType
]

{ #category : #testing }
SYMLMetaType >> convertedExplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super convertedExplicitlyInto: targetType
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

{ #category : #testing }
SYMLMetaType >> node: node coercedImplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super node: node coercedImplicitlyInto: targetType
]

{ #category : #testing }
SYMLMetaType >> node: node convertedExplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super node: node convertedExplicitlyInto: targetType
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
