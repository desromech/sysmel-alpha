Class {
	#name : #MbndLiteralArrayToArrayConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndLiteralArrayToArrayConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ sourceType isLiteralArrayType and: [ targetType isArrayType ]
]

{ #category : #hooks }
MbndLiteralArrayToArrayConversionRule >> specificCastNodeClass [
	^ MbndAstLiteralArrayToArrayCastNode
]
