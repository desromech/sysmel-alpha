Class {
	#name : #MbndLiteralChacterToDynamicObjectTypeConversionRule,
	#superclass : #MbndLiteralValueTypeChangeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndLiteralChacterToDynamicObjectTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| literal target |
	node expression isLiteralValueNode ifFalse: [ self error: 'Expected a literal here' at: node ].
	
	literal := node expression.
	target := node targetType.
	^ literal copy
		value: literal value asCharacter;
		type: target;
		yourself
]
