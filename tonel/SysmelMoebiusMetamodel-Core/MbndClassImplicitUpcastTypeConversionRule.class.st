Class {
	#name : #MbndClassImplicitUpcastTypeConversionRule,
	#superclass : #MbndClassPointerTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndClassImplicitUpcastTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| sourceClassType targetClassType |
	sourceClassType := sourceType baseType withoutTopDecorations.
	targetClassType := targetType baseType withoutTopDecorations.
	(sourceClassType isAbstractClassType or: [ targetClassType isAbstractClassType ]) ifFalse: [ ^ false ].
	
	^ sourceClassType isSubtypeOf: targetClassType
]
