Class {
	#name : #SYMLGCClassCastRule,
	#superclass : #SYMLReinterpretPointerTypeConversionRule,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #testing }
SYMLGCClassCastRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ sourceType isSysmelGCClass and: [targetType isSysmelGCClass]
]
