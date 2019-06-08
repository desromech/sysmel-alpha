Class {
	#name : #MbndPointerExplicitVoidReinterpretTypeConversionRule,
	#superclass : #MbndPointerReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPointerExplicitVoidReinterpretTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	| rawSourceType rawTargetType |
	rawSourceType := sourceType baseType withoutTopDecorations.
	rawTargetType := targetType baseType withoutTopDecorations.
	^ rawSourceType isVoidType xor: rawTargetType isVoidType
]
