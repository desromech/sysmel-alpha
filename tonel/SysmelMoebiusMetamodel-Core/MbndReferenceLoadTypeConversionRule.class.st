Class {
	#name : #MbndReferenceLoadTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndReferenceLoadTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndReferenceLoadTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	^ MbndAstReferenceLoadNode new
		position: node position;
		reference: node expression;
		type: node type;
		yourself
]
