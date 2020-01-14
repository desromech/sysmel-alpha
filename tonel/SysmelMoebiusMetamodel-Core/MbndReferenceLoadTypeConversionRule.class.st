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
	self assert: node isGenericCastNode.
	^ analyzer analyzeNodeIfNeeded: (self specificCastNodeClass new
		position: node;
		reference: node expression;
		yourself)
]

{ #category : #hooks }
MbndReferenceLoadTypeConversionRule >> specificCastNodeClass [
	^ MbndAstReferenceLoadNode
]
