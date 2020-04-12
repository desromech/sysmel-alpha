Class {
	#name : #MbndNumberToBooleanConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndNumberToBooleanConversionRule >> specificCastNodeClass [
	^ MbndAstNumberToBooleanCastNode
]
