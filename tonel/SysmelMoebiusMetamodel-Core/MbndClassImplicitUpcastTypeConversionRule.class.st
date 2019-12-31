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
	(sourceType hasPointerRankImplicitlyConvertibleTo: targetType pointerRank) ifFalse: [ ^ false ].
	
	(sourceClassType isAbstractClassType or: [ targetClassType isAbstractClassType ]) ifFalse: [ ^ false ].
	^ sourceClassType isSubtypeOf: targetClassType
]
