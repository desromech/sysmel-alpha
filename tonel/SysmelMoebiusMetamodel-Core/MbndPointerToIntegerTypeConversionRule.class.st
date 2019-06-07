Class {
	#name : #MbndPointerToIntegerTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndPointerToIntegerTypeConversionRule >> specificCastNodeClass [
	^ MbndAstPointerToIntegerCastNode
]
