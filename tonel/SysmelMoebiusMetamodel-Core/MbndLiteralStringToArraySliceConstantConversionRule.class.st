Class {
	#name : #MbndLiteralStringToArraySliceConstantConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndLiteralStringToArraySliceConstantConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndLiteralStringToArraySliceConstantConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| literal target literalString prefixedStringType newLiteralValue literalStringEncodedSize codePointSize |
	node expression isLiteralValueNode ifFalse: [ self error: 'Expected a literal here' at: node ].
	literal := node expression.
	target := node targetType.
	literalString := literal value.
	literalStringEncodedSize := 0.
	codePointSize := target elementType withoutDecorations instanceSize.
	codePointSize = 1 ifTrue: [
		literalStringEncodedSize := literalString slvmUTF8EncodedSize.
	].
	codePointSize = 2 ifTrue: [ 
		literalStringEncodedSize := literalString slvmUTF16EncodedSize.
	].
	codePointSize = 4 ifTrue: [ 
		literalStringEncodedSize := literalString slvmUTF32EncodedSize.
	].
	
	prefixedStringType := target withoutReferences withoutDecorations.
	newLiteralValue := MbndAggregateTypeInstanceValue new
			type: prefixedStringType;
			slots: {
				literalString.
				literalStringEncodedSize .
			}.
	^ literal copy
		value: newLiteralValue;
		type: target;
		yourself
]
