Class {
	#name : #MbndDynamicObjectToIntegerConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndDynamicObjectToIntegerConversionRule >> specificCastNodeClass [
	^ MbndAstDynamicObjectToIntegerCastNode
]
