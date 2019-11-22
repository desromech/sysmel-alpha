Class {
	#name : #MbndWrapInLiteralValueNodeTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndWrapInLiteralValueNodeTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndWrapInLiteralValueNodeTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	node expression isLiteralValueNode ifTrue: [
		^ analyzer analyzeNodeIfNeeded: (MbndAstQuoteNode new
				position: node;
				expression: node expression;
				yourself)
	].

	(node expression type isMetaType or: [ node expression type isCompilerObjectType ]) ifTrue: [ 
		^ analyzer analyzeNodeIfNeeded: (MbndAstConvertToASTNodeCastNode new
				position: node;
				expression: node expression;
				targetType: node targetType;
				yourself)
	].
	

	self halt
]
