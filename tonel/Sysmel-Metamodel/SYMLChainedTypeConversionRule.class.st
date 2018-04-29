Class {
	#name : #SYMLChainedTypeConversionRule,
	#superclass : #SYMLTypeConversionRule,
	#instVars : [
		'intermediateType',
		'intermediateRule',
		'nextRule'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLChainedTypeConversionRule >> convertSSAValue: sourceValue to: targetType with: builder at: messageNode [
	| intermediateValue |
	intermediateValue := intermediateRule convertSSAValue: sourceValue to: intermediateType with: builder at: messageNode.
	^ nextRule convertSSAValue: intermediateValue to: targetType with: builder at: messageNode
]

{ #category : #'as yet unclassified' }
SYMLChainedTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	| intermediateValue |
	intermediateValue := intermediateRule convertValue: value into: intermediateType at: coercionPosition.
	^ nextRule convertValue: intermediateValue into: targetType at: coercionPosition
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> intermediateRule [
	^ intermediateRule
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> intermediateRule: anObject [
	intermediateRule := anObject
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> intermediateType [
	^ intermediateType
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> intermediateType: anObject [
	intermediateType := anObject
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> nextRule [
	^ nextRule
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> nextRule: anObject [
	nextRule := anObject
]
