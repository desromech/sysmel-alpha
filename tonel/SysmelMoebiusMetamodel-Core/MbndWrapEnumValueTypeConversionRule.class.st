Class {
	#name : #MbndWrapEnumValueTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndWrapEnumValueTypeConversionRule >> specificCastNodeClass [
	^ MbndAstWrapEnumValueCastNode
]
