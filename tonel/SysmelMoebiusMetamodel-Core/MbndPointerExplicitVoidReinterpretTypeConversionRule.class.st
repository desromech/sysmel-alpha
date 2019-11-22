Class {
	#name : #MbndPointerExplicitVoidReinterpretTypeConversionRule,
	#superclass : #MbndPointerReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPointerExplicitVoidReinterpretTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| rawSourceType rawTargetType |
	(sourceType isPointerType and: [ targetType isPointerType ]) ifFalse: [ ^ false ].
	rawSourceType := sourceType baseType withoutTopDecorations.
	rawTargetType := targetType baseType withoutTopDecorations.
	^ rawSourceType isVoidType xor: rawTargetType isVoidType
]
