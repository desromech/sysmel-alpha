Class {
	#name : #MbndTemporaryReferenceAsReferenceRule,
	#superclass : #MbndPointerReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndTemporaryReferenceAsReferenceRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| sourceBaseType targetBaseType |
	(sourceType isTemporaryReferenceType and: [ targetType isReferenceType ]) ifFalse: [ ^ false ].

	sourceBaseType := sourceType baseType.
	targetBaseType := targetType baseType.
	targetBaseType isConstantType ifTrue: [ targetBaseType := targetBaseType baseType ].
	^ sourceBaseType == targetBaseType
]
