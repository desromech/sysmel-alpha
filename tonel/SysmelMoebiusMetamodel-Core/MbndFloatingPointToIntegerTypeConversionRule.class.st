Class {
	#name : #MbndFloatingPointToIntegerTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndFloatingPointToIntegerTypeConversionRule >> specificCastNodeClass [
	^ MbndAstFloatingPointToIntegerCastNode
]
