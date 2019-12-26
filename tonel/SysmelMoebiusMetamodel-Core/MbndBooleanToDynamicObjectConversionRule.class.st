Class {
	#name : #MbndBooleanToDynamicObjectConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndBooleanToDynamicObjectConversionRule >> specificCastNodeClass [
	^ MbndAstBooleanToDynamicObjectCastNode
]
