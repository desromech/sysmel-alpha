Class {
	#name : #MbndLiteralToBestTargetTypeConversionRule,
	#superclass : #MbndLiteralToTargetTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndLiteralToBestTargetTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	node isLiteralValueNode ifTrue: [ 
		^ (targetType isAcceptableLiteralValue: node value) and: [ targetType isStandardConcreteTypeForLiteralValueNode: node ]
	].

	^ false.
]

{ #category : #acccessing }
MbndLiteralToBestTargetTypeConversionRule >> conversionCost [
	^ 5
]
