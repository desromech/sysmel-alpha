Class {
	#name : #MbndTupleToArrayTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndTupleToArrayTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ sourceType isTupleType and: [ targetType isArrayType ]
]

{ #category : #hooks }
MbndTupleToArrayTypeConversionRule >> specificCastNodeClass [
	^ MbndAstTupleToArrayCastNode
]
