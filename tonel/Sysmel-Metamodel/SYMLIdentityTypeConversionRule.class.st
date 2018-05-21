Class {
	#name : #SYMLIdentityTypeConversionRule,
	#superclass : #SYMLTypeConversionRule,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'as yet unclassified' }
SYMLIdentityTypeConversionRule >> convertSSAValue: sourceValue to: targetType with: builder at: aPosition [
	^ sourceValue
]

{ #category : #'as yet unclassified' }
SYMLIdentityTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	^ value sameValueButWithType: targetType
]
