Class {
	#name : #MbndLiteralStringToNativePrefixedStringConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndLiteralStringToNativePrefixedStringConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndLiteralStringToNativePrefixedStringConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| literal target literalString prefixedStringType newLiteralValue |
	node expression isLiteralValueNode ifFalse: [ self error: 'Expected a literal here' at: node ].
	literal := node expression.
	target := node targetType.
	literalString := literal value utf8Encoded.
	
	prefixedStringType := target withoutReferences withoutDecorations.
	newLiteralValue := MbndAggregateTypeInstanceValue new
			type: prefixedStringType;
			slots: { literalString size .
				MbndAggregateTypeInstanceValue new
					type: prefixedStringType slotLayout slots second type;
					slots: literalString
			}.

	^ literal copy
		value: newLiteralValue;
		type: target;
		yourself
]
