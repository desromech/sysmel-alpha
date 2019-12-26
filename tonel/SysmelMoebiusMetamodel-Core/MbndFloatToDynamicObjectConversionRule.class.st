Class {
	#name : #MbndFloatToDynamicObjectConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndFloatToDynamicObjectConversionRule >> specificCastNodeClass [
	^ MbndAstFloatToDynamicObjectCastNode
]
