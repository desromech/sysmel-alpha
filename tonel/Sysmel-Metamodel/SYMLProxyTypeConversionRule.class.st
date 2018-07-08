Class {
	#name : #SYMLProxyTypeConversionRule,
	#superclass : #SYMLTypeConversionRule,
	#instVars : [
		'rule'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #testing }
SYMLProxyTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ rule canBeUsedToConvertFrom: sourceType into: targetType
]

{ #category : #'as yet unclassified' }
SYMLProxyTypeConversionRule >> coercionCost [
	^ rule coercionCost
]

{ #category : #'as yet unclassified' }
SYMLProxyTypeConversionRule >> convertSSAValue: sourceValue to: targetType with: builder at: messageNode [
	^ rule convertSSAValue: sourceValue to: targetType with: builder at: messageNode
]

{ #category : #'as yet unclassified' }
SYMLProxyTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	^ rule convertValue: value into: targetType at: coercionPosition
]

{ #category : #accessing }
SYMLProxyTypeConversionRule >> rule [
	^ rule
]

{ #category : #accessing }
SYMLProxyTypeConversionRule >> rule: anObject [
	rule := anObject
]
