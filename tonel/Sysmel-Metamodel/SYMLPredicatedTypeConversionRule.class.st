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
	^ predicate value: sourceType value: targetType
]

{ #category : #accessing }
SYMLPredicatedTypeConversionRule >> predicate [
	^ predicate
]

{ #category : #accessing }
SYMLPredicatedTypeConversionRule >> predicate: anObject [
	predicate := anObject
]
