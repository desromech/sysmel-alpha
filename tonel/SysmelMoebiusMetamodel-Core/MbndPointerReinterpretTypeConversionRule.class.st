Class {
	#name : #MbndPointerReinterpretTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndPointerReinterpretTypeConversionRule >> specificCastNodeClass [
	^ MbndAstPointerReinterpretCastNode
]
