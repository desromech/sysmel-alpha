Class {
	#name : #MbndUnwrapEnumValueTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndUnwrapEnumValueTypeConversionRule >> specificCastNodeClass [
	^ MbndAstUnwrapEnumValueCastNode
]
