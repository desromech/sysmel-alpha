Class {
	#name : #SYMLTypeKindConversionRule,
	#superclass : #SYMLDeferredTypeConversionRule,
	#instVars : [
		'targetTypeKind'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #testing }
SYMLTypeKindConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	targetType == targetTypeKind ifTrue: [ ^ true ].
	
	targetTypeKind isSysmelTrait ifTrue: [ ^ targetType isSysmelKindOf: targetTypeKind ].
	^ false
]

{ #category : #testing }
SYMLTypeKindConversionRule >> isTypeKindConversion [
	^ true
]

{ #category : #accessing }
SYMLTypeKindConversionRule >> targetTypeKind [
	^ targetTypeKind
]

{ #category : #accessing }
SYMLTypeKindConversionRule >> targetTypeKind: anObject [
	targetTypeKind := anObject
]
