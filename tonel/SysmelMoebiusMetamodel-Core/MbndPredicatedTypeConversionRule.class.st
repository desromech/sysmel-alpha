Class {
	#name : #MbndPredicatedTypeConversionRule,
	#superclass : #MbndProxyTypeConversionRule,
	#instVars : [
		'predicate'
	],
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPredicatedTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	predicate numArgs = 2 ifTrue: [ 
		^ predicate value: sourceType value: targetType
	].
	^ predicate value: node value: sourceType value: targetType
]

{ #category : #accessing }
MbndPredicatedTypeConversionRule >> predicate [
	^ predicate
]

{ #category : #accessing }
MbndPredicatedTypeConversionRule >> predicate: anObject [
	predicate := anObject
]
