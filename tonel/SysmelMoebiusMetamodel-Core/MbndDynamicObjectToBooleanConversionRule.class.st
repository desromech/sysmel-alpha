Class {
	#name : #MbndDynamicObjectToBooleanConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndDynamicObjectToBooleanConversionRule >> specificCastNodeClass [
	^ MbndAstDynamicObjectToBooleanCastNode
]
