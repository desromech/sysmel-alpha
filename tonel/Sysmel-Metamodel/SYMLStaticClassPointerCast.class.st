Class {
	#name : #SYMLStaticClassPointerCast,
	#superclass : #SYMLReinterpretPointerTypeConversionRule,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'as yet unclassified' }
SYMLStaticClassPointerCast >> convertSSAValue: sourceValue to: targetType with: builder at: aPosition [
	^ builder bitCast: sourceValue target: targetType ssaType
]
