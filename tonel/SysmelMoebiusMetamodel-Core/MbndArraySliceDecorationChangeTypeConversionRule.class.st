Class {
	#name : #MbndArraySliceDecorationChangeTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndArraySliceDecorationChangeTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	sourceType isArraySliceType ifFalse: [ ^ false ].
	targetType isArraySliceType ifFalse: [ ^ false ].
	sourceType elementType ifNil: [ ^ false ].
	targetType elementType ifNil: [ ^ false ].

	sourceType elementType withoutDecorations = targetType elementType withoutDecorations ifFalse: [ ^ false ].
	^ sourceType elementType isConstantType = targetType elementType isConstantType or: [ sourceType elementType isConstantType not and: [targetType elementType isConstantType] ]
]

{ #category : #hooks }
MbndArraySliceDecorationChangeTypeConversionRule >> specificCastNodeClass [
	^ MbndAstArraySliceDecorationChangeCastNode
]
