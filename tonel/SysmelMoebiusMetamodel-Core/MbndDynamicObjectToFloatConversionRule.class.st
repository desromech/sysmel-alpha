Class {
	#name : #MbndDynamicObjectToFloatConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndDynamicObjectToFloatConversionRule >> specificCastNodeClass [
	^ MbndAstDynamicObjectToFloatCastNode
]
