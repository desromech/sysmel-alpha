Class {
	#name : #MbndArrayReferenceToArraySliceConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndArrayReferenceToArraySliceConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| sourceElementType arrayType |
	targetType isArraySliceType ifFalse: [ ^ false ].
	targetType elementType ifNil: [ ^ false ].
	sourceType isReferenceType ifFalse: [ ^ false ].
	arrayType := sourceType baseType withoutDecorations.
	
	arrayType isArrayType ifFalse: [ ^ false ].
	(arrayType elements isNil or: [ arrayType elements = 0 ]) ifTrue: [ ^ false ].
	
	sourceElementType := sourceType baseType withoutDecorations elementType withDecorations: sourceType baseType decorations.
	sourceElementType withoutDecorations = targetType elementType withoutDecorations ifFalse: [ ^ false ].
	^ sourceElementType isConstantType = targetType elementType isConstantType or: [ sourceElementType isConstantType not and: [targetType elementType isConstantType] ]
]

{ #category : #'as yet unclassified' }
MbndArrayReferenceToArraySliceConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| arrayType builder firstElementPointer arraySlice asArraySliceNode |
	arrayType := node expression type withoutReferences withoutTopDecorations.
	self assert: arrayType isArrayType.
	self assert: (arrayType elements isNotNil and: [arrayType elements > 0]).
	
	builder := analyzer astBuilder.
	firstElementPointer := (builder array: node expression elementReferenceAt: (builder literalInteger: 0))
		position: node;
		yourself.
	firstElementPointer := (builder referenceAsPointer: firstElementPointer)
		position: node;
		yourself.
	asArraySliceNode := (builder pointer: firstElementPointer toArraySliceFrom: (builder literalInteger: 0) until: (builder literalInteger: arrayType elements))
		position: node;
		yourself.
	^ analyzer visitNode: (node copy expression: asArraySliceNode)
]
