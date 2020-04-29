Class {
	#name : #MbndCopyIntoTemporaryTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #acccessing }
MbndCopyIntoTemporaryTypeConversionRule >> conversionCost [
	^ 20
]

{ #category : #'as yet unclassified' }
MbndCopyIntoTemporaryTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	self assert: node isGenericCastNode.
	^ analyzer analyzeNodeIfNeeded: (self specificCastNodeClass new
		position: node;
		value: node expression;
		yourself)
]

{ #category : #hooks }
MbndCopyIntoTemporaryTypeConversionRule >> specificCastNodeClass [
	^ MbndAstCopyIntoTemporaryVariableNode
]
