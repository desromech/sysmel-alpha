Class {
	#name : #SYMLReinterpretPointerTypeConversionRule,
	#superclass : #SYMLIdentityTypeConversionRule,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'as yet unclassified' }
SYMLReinterpretPointerTypeConversionRule >> convertSSAValue: sourceValue to: targetType with: builder at: aPosition [
	^ builder bitCast: sourceValue target: targetType ssaType
]
