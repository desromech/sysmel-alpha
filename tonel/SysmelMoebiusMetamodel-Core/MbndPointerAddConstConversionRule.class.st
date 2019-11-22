Class {
	#name : #MbndPointerAddConstConversionRule,
	#superclass : #MbndPointerReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPointerAddConstConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	((sourceType isPointerType and: [ targetType isPointerType ]) or:
	[(sourceType isReferenceType and: [ targetType isReferenceType ])]) ifFalse: [ ^ false ].

	^ (sourceType baseType withoutTopDecorations == targetType baseType withoutTopDecorations)
		and: [ sourceType baseType isConstantType not and: [ targetType baseType isConstantType ] ]
]
