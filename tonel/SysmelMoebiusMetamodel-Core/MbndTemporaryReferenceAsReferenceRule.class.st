Class {
	#name : #MbndTemporaryReferenceAsReferenceRule,
	#superclass : #MbndPointerReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndTemporaryReferenceAsReferenceRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	(sourceType isTemporaryReferenceType and: [ targetType isReferenceType ]) ifFalse: [ ^ false ].

	^ sourceType baseType == targetType baseType
]
