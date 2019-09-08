Class {
	#name : #MbndDecorationChangeTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndDecorationChangeTypeConversionRule >> specificCastNodeClass [
	^ MbndAstDecorationChangeTypeCastNode
]
