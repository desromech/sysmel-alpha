Class {
	#name : #MbndToCompilerObjectTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndToCompilerObjectTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ targetType isCompilerObjectType and: [ targetType isASTNodeType not ]
]

{ #category : #acccessing }
MbndToCompilerObjectTypeConversionRule >> conversionCost [
	^ 10
]

{ #category : #'as yet unclassified' }
MbndToCompilerObjectTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| literal target |
	node isLiteralValueNode ifTrue: [ 
		literal := node expression.
		target := node targetType.
		^ literal copy
			value: (target legalizeLiteralValue: literal value);
			type: target;
			yourself
	].

	^ analyzer visitNode: (MbndAstConvertToCompilerObjectCastNode new
		position: node;
		expression: node expression;
		targetType: node targetType;
		yourself)
]
