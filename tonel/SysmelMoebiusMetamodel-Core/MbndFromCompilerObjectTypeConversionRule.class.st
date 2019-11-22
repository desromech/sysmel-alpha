Class {
	#name : #MbndFromCompilerObjectTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndFromCompilerObjectTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ targetType isCompilerObjectType not and:
	[sourceType isCompilerObjectType and: [ sourceType isASTNodeType not ]]
]

{ #category : #testing }
MbndFromCompilerObjectTypeConversionRule >> conversionCost [
	^ 10
]

{ #category : #testing }
MbndFromCompilerObjectTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| literal target |
	node isLiteralValueNode ifTrue: [ 
		literal := node expression.
		target := node targetType.
		^ literal copy
			value: (target legalizeLiteralValue: literal value);
			type: target;
			yourself
	].

	^ analyzer visitNode: (MbndAstConvertFromCompilerObjectCastNode new
		position: node;
		expression: node expression;
		targetType: node targetType;
		yourself)
]
