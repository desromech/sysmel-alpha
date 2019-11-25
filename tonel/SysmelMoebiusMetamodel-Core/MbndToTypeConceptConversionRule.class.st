Class {
	#name : #MbndToTypeConceptConversionRule,
	#superclass : #MbndToCompilerObjectTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndToTypeConceptConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ targetType isTypeConcept and: [ targetType doesTypeComplyWithConcept: sourceType ]
]
