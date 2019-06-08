Class {
	#name : #MbndPointerImplicitVoidReinterpretTypeConversionRule,
	#superclass : #MbndPointerExplicitVoidReinterpretTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPointerImplicitVoidReinterpretTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	(super canBeUsedToConvertFrom: sourceType into: targetType) ifFalse: [ ^ false ].
	
	"No implicit void pointer -> any pointer."
	sourceType baseType withoutTopDecorations isVoidType ifTrue: [ ^ false ].
	
	"No implicit any const pointer -> any pointer."
	sourceType baseType isConstantType ifTrue: [
		targetType baseType isConstantType ifFalse: [
			^ false
		]
	].
	
	^ true
]
