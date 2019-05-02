Class {
	#name : #MbndLiteralToTargetTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndLiteralToTargetTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	node isLiteralValueNode ifTrue: [ 
		^ targetType isAcceptableLiteralValue: node value
	].

	^ false.
]

{ #category : #'as yet unclassified' }
MbndLiteralToTargetTypeConversionRule >> postProcessCastNode: node [
	| literal target |
	node expression isLiteralValueNode ifFalse: [
		self error: 'Literal to target type cast requires a literal value node.' at: node
	].

	literal := node expression.
	target := node targetType.
	^ literal copy
		value: (target legalizeLiteralValue: literal value);
		type: target;
		yourself
]
