Class {
	#name : #MbndDynamicObjectToCharacterConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndDynamicObjectToCharacterConversionRule >> specificCastNodeClass [
	^ MbndAstDynamicObjectToCharacterCastNode
]
