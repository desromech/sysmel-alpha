Class {
	#name : #MbndSignExtensionTypeConversionRule,
	#superclass : #MbndNumericTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndSignExtensionTypeConversionRule >> specificCastNodeClass [
	^ MbndAstSignExtensionCastNode
]
