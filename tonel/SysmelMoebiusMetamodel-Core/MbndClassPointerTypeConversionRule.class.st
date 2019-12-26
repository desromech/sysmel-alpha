Class {
	#name : #MbndClassPointerTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndClassPointerTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| sourceClassType targetClassType |
	sourceType withoutTopDecorations isReferenceType == targetType withoutTopDecorations isReferenceType ifFalse: [ ^ false ].

	sourceClassType := sourceType asUndecoratedClassType.
	targetClassType := targetType asUndecoratedClassType.
	
	(sourceClassType isAbstractClassType or: [ targetClassType isAbstractClassType ]) ifFalse: [ ^ false ].
	
	^ (sourceClassType isSubtypeOf: targetClassType) or: [ targetClassType isSubtypeOf: targetClassType]
]

{ #category : #hooks }
MbndClassPointerTypeConversionRule >> specificCastNodeClass [
	^ MbndAstStaticClassPointerCastNode
]
