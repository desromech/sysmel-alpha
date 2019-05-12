Class {
	#name : #MbndBitCastTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndBitCastTypeConversionRule >> specificCastNodeClass [
	^ MbndAstBitCastNode
]
