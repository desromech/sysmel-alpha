Class {
	#name : #MbndWrapInLiteralValueNodeTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndWrapInLiteralValueNodeTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	node expression isLiteralValueNode ifTrue: [
		^ analyzer analyzeNodeIfNeeded: (MbndAstQuoteNode new
				position: node;
				expression: node expression;
				yourself)
	].

	self halt
]
