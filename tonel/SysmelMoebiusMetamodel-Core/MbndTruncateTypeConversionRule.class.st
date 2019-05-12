Class {
	#name : #MbndTruncateTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndTruncateTypeConversionRule >> specificCastNodeClass [
	^ MbndAstTruncateCastNode
]
