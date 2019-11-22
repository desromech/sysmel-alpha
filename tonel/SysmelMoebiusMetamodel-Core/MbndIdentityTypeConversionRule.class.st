"
I am a type conversion rule that does not change thet itself, but it only changes its type.
"
Class {
	#name : #MbndIdentityTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndIdentityTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ sourceType == targetType
]

{ #category : #testing }
MbndIdentityTypeConversionRule >> conversionCost [
	^ 0
]

{ #category : #'as yet unclassified' }
MbndIdentityTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	^ node expression
]
