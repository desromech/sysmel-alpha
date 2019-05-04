Class {
	#name : #MbndWrapInLiteralValueNodeTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndWrapInLiteralValueNodeTypeConversionRule >> postProcessCastNode: node [
	node expression isLiteralValueNode ifTrue: [
		^ node copy
			expression: (MbndAstQuoteNode new
				position: node;
				expression: node expression;
				yourself)
	].

	self halt
]