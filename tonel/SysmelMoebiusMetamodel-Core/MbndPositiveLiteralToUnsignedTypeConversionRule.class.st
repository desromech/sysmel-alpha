Class {
	#name : #MbndPositiveLiteralToUnsignedTypeConversionRule,
	#superclass : #MbndLiteralValueTypeChangeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPositiveLiteralToUnsignedTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	node ifNil: [ ^ false ].
	node isLiteralValueNode ifFalse: [ ^ false ].
	node value >= 0 ifFalse: [ ^ false ].
	^ targetType isAcceptableLiteralValueInRange: node value
]
