Class {
	#name : #SYMLAbstractMetaType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'instanceType'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #testing }
SYMLAbstractMetaType >> coercedImplicitlyInto: targetType [
	(targetType == self compilationTarget compilerObjectType or: [ self isSysmelKindOf: targetType ]) ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super coercedImplicitlyInto: targetType
]

{ #category : #accessing }
SYMLAbstractMetaType >> compilationTarget [
	^ instanceType compilationTarget
]

{ #category : #testing }
SYMLAbstractMetaType >> convertedExplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super convertedExplicitlyInto: targetType
]

{ #category : #initialization }
SYMLAbstractMetaType >> initializeFromOldMetaType: oldMetaType [
	oldMetaType ifNil: [ ^ self ].
	self addTraits: oldMetaType usedTraits
]

{ #category : #accessing }
SYMLAbstractMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
SYMLAbstractMetaType >> instanceType: anObject [
	instanceType := anObject
]

{ #category : #testing }
SYMLAbstractMetaType >> isMetaType [
	^ true
]

{ #category : #testing }
SYMLAbstractMetaType >> node: node coercedImplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].

	^ super node: node coercedImplicitlyInto: targetType
]

{ #category : #testing }
SYMLAbstractMetaType >> node: node convertedExplicitlyInto: targetType [
	targetType == self compilationTarget compilerObjectType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	^ super node: node convertedExplicitlyInto: targetType
]
