Class {
	#name : #MbndToCompilerObjectTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndToCompilerObjectTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	sourceType isReferenceType ifTrue: [ ^ false ].
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
