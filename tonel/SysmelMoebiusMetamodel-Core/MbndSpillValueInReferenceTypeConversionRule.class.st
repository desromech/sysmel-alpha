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
	self assert: node isGenericCastNode.
	self assert: node targetType isReferenceType.
	^ analyzer visitNode: (node copy
		expression: (MbndAstCopyIntoTemporaryVariableNode new
			position: node;
			value: node expression;
			avoidCopy: node targetType baseType isConstantType;
			yourself);
		type: nil)
		
]
