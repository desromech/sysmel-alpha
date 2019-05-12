Class {
	#name : #MbndZeroExtensionTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndZeroExtensionTypeConversionRule >> specificCastNodeClass [
	^ MbndAstZeroExtensionCastNode
]
