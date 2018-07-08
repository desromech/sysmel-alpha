Class {
	#name : #SYMLGCSuperclassCastRule,
	#superclass : #SYMLReinterpretPointerTypeConversionRule,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #testing }
SYMLGCSuperclassCastRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ sourceType isSysmelGCClass and: [targetType isSysmelGCClass and: [ sourceType isSubclassOf: targetType ]] 
]
