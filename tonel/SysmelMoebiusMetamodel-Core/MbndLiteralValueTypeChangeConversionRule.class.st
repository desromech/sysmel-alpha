Class {
	#name : #MbndLiteralValueTypeChangeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndLiteralValueTypeChangeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndLiteralValueTypeChangeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| literal target |
	node expression isLiteralValueNode ifFalse: [ self error: 'Expected a literal here' at: node ].
	
	literal := node expression.
	target := node targetType.
	^ literal copy
		value: (target legalizeLiteralValue: literal value);
		type: target;
		yourself
]
