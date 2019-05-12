Class {
	#name : #MbndFloatingPointSizeTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndFloatingPointSizeTypeConversionRule >> specificCastNodeClass [
	^ MbndAstFloatingPointSizeCastNode
]
