Class {
	#name : #SYMLPredicatedTypeConversionRule,
	#superclass : #SYMLProxyTypeConversionRule,
	#instVars : [
		'predicate'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #testing }
SYMLPredicatedTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	predicate numArgs = 2 ifTrue: [ 
		^ predicate value: sourceType value: targetType
	].
	^ predicate value: nil value: sourceType value: targetType
]

{ #category : #testing }
SYMLPredicatedTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	predicate numArgs = 2 ifTrue: [ 
		^ predicate value: sourceType value: targetType
	].
	^ predicate value: node value: sourceType value: targetType
]

{ #category : #accessing }
SYMLPredicatedTypeConversionRule >> predicate [
	^ predicate
]

{ #category : #accessing }
SYMLPredicatedTypeConversionRule >> predicate: anObject [
	predicate := anObject
]
