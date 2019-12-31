Class {
	#name : #MbndPrimitiveVectorTypeElementConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPrimitiveVectorTypeElementConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	sourceType isPrimitiveVectorType ifFalse: [ ^ false ].
	targetType isPrimitiveVectorType ifFalse: [ ^ false ].
	sourceType elements = targetType elements ifFalse: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
MbndPrimitiveVectorTypeElementConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| sourceType targetType sourceElementType targetElementType specificCastNodeClass |
	self assert: node isGenericCastNode.
	sourceType := node expression type.
	targetType := node targetType.
	
	sourceElementType := sourceType elementType.
	targetElementType := targetType elementType.
	
	specificCastNodeClass := 
	(sourceElementType isPrimitiveFloatType or: [ targetElementType isPrimitiveFloatType ]) ifTrue: [ 
		(sourceElementType isPrimitiveFloatType and: [ targetElementType isPrimitiveFloatType ]) ifTrue: [
			MbndAstFloatingPointSizeCastNode
		] ifFalse: [
			sourceElementType isPrimitiveFloatType
				ifTrue: [ MbndAstFloatingPointToIntegerCastNode ]
				ifFalse: [ MbndAstIntegerToFloatingPointCastNode ].
		].
	] ifFalse: [
		"Int cast"
		sourceElementType size > targetElementType size ifTrue: [
			MbndAstTruncateCastNode
		] ifFalse: [ 
			sourceElementType size = targetElementType size ifTrue: [
				MbndAstBitCastNode
			] ifFalse: [ 
				sourceElementType size isSigned ifTrue: [
					MbndAstSignExtensionCastNode 
				] ifFalse:[
					MbndAstZeroExtensionCastNode
				]
			]
		].
	].

	^ analyzer analyzeNodeIfNeeded: (specificCastNodeClass new
		position: node;
		expression: node expression;
		targetType: node targetType;
		yourself)
]
