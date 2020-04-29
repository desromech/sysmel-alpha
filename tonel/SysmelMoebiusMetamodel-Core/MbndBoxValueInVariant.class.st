Class {
	#name : #MbndBoxValueInVariant,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndBoxValueInVariant >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| targetVariantType |
	targetVariantType := targetType withoutReferences withoutTopDecorations.
	targetVariantType isVariantUnionType ifFalse: [ ^ false ].
	sourceType withoutReferences withoutTopDecorations isVariantUnionType ifTrue: [ ^ false ].
	^ (targetVariantType findBestSuitableValueTypeFor: sourceType node: node) size = 1
]

{ #category : #'as yet unclassified' }
MbndBoxValueInVariant >> postProcessCastNode: node withAnalyzer: analyzer [
	| boxedValueTypes typeSelector newNode targetVariantType |
	targetVariantType := node targetType withoutReferences withoutTopDecorations.
	boxedValueTypes := targetVariantType findBestSuitableValueTypeFor: node expression type node: node expression.
	self assert: boxedValueTypes size = 1.

	typeSelector := targetVariantType getTypeSelectorFor: boxedValueTypes first.
	newNode := MbndAstVariantBoxCreateNode new
		position: node;
		variantType: targetVariantType;
		typeSelector: typeSelector;
		boxedValue: (node expression);
		yourself.
	self assert: node isGenericCastNode.
	^ analyzer visitNode: (node copy
		expression: newNode;
		type: nil)
]
