Class {
	#name : #MbndToAbstractMetaTypeTypeConversionRule,
	#superclass : #MbndToCompilerObjectTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndToAbstractMetaTypeTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ sourceType isMetaType and: [ targetType == targetType compilationTarget abstractMetaType ]
]

{ #category : #acccessing }
MbndToAbstractMetaTypeTypeConversionRule >> conversionCost [
	^ 0
]
