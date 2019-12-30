Class {
	#name : #MbndCharacterToDynamicObjectConversionRule,
	#superclass : #MbndDynamicTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndCharacterToDynamicObjectConversionRule >> specificCastNodeClass [
	^ MbndAstCharacterToDynamicObjectCastNode
]
