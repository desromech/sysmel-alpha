Class {
	#name : #MbndIntegerToFloatingPointTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndIntegerToFloatingPointTypeConversionRule >> specificCastNodeClass [
	^ MbndAstIntegerToFloatingPointCastNode
]
