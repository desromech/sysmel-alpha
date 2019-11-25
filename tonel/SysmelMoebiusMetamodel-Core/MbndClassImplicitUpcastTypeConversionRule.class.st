Class {
	#name : #MbndClassImplicitUpcastTypeConversionRule,
	#superclass : #MbndClassPointerTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndClassImplicitUpcastTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| sourceClassType targetClassType |
	sourceClassType := sourceType asUndecoratedClassType.
	targetClassType := targetType asUndecoratedClassType.
	sourceType withoutTopDecorations isReferenceType == targetType withoutTopDecorations isReferenceType ifFalse: [ ^ false ].
	sourceType withoutTopDecorations isPointerType == targetType withoutTopDecorations isPointerType ifFalse: [ ^ false ].
	
	(sourceClassType isAbstractClassType or: [ targetClassType isAbstractClassType ]) ifFalse: [ ^ false ].
	^ sourceClassType isSubtypeOf: targetClassType
]
