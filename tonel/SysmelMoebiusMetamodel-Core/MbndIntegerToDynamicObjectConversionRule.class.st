Class {
	#name : #MbndIntegerToDynamicObjectConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndIntegerToDynamicObjectConversionRule >> specificCastNodeClass [
	^ MbndAstIntegerToDynamicObjectCastNode
]
