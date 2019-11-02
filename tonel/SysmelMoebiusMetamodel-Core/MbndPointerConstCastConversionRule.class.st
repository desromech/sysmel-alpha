Class {
	#name : #MbndPointerConstCastConversionRule,
	#superclass : #MbndPointerReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPointerConstCastConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	((sourceType isPointerType and: [ targetType isPointerType ]) or:
	[(sourceType isReferenceType and: [ targetType isReferenceType ])]) ifFalse: [ ^ false ].

	^ (sourceType baseType withoutTopDecorations == targetType baseType withoutTopDecorations)
		and: [ sourceType baseType isConstantType ~= targetType baseType isConstantType ]
]
