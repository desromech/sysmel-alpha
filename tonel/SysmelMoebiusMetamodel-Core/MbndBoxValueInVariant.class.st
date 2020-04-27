Class {
	#name : #MbndBoxValueInVariant,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndBoxValueInVariant >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	targetType isVariantUnionType ifFalse: [ ^ false ].
	sourceType withoutReferences withoutDecorations isVariantUnionType ifTrue: [ ^ false ].
	^ (targetType findBestSuitableValueTypeFor: sourceType node: node) size = 1
]

{ #category : #'as yet unclassified' }
MbndBoxValueInVariant >> postProcessCastNode: node withAnalyzer: analyzer [
	| boxedValueTypes typeSelector newNode |
	boxedValueTypes := node targetType findBestSuitableValueTypeFor: node expression type node: node expression.
	self assert: boxedValueTypes size = 1.

	typeSelector := node targetType getTypeSelectorFor: boxedValueTypes first.
	newNode := MbndAstVariantBoxCreateNode new
		variantType: node targetType;
		typeSelector: typeSelector;
		boxedValue: (node expression);
		yourself.
	^ analyzer visitNode: newNode
]
