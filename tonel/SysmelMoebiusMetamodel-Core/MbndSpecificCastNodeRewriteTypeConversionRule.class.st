Class {
	#name : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndSpecificCastNodeRewriteTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndSpecificCastNodeRewriteTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	self assert: node isGenericCastNode.
	^ analyzer analyzeNodeIfNeeded: (self specificCastNodeClass new
		position: node;
		expression: node expression;
		targetType: node targetType;
		yourself)
]

{ #category : #hooks }
MbndSpecificCastNodeRewriteTypeConversionRule >> specificCastNodeClass [
	self subclassResponsibility
]
