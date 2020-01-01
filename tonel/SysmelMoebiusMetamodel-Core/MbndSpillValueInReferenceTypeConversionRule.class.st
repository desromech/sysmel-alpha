Class {
	#name : #MbndSpillValueInReferenceTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndSpillValueInReferenceTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndSpillValueInReferenceTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| localNode |
	localNode := (analyzer astBuilder defineLocalVariable: #_ withValueType: nil withInitialValue: node expression)
		position: node;
		mutable.
	self assert: node isGenericCastNode.
	^ analyzer visitNode: (node copy
		expression: localNode;
		type: nil)
]
