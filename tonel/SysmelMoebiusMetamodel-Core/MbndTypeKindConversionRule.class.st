Class {
	#name : #MbndTypeKindConversionRule,
	#superclass : #MbndProxyTypeConversionRule,
	#instVars : [
		'targetTypeKind'
	],
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndTypeKindConversionRule >> applyConversionToLiteralCastNode: literalCastNode [
	^ rule applyConversionToLiteralCastNode: literalCastNode
]

{ #category : #converting }
MbndTypeKindConversionRule >> asMbndTypeConversionRuleTo: targetType [
	^ self copy targetTypeKind: targetType; yourself
]

{ #category : #testing }
MbndTypeKindConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	targetType == targetTypeKind ifFalse: [ ^ false ].
	^ super canBeUsedToConvertNode: node from: sourceType into: targetType
]

{ #category : #testing }
MbndTypeKindConversionRule >> isTypeKindConversion [
	^ true
]

{ #category : #accessing }
MbndTypeKindConversionRule >> targetTypeKind [
	^ targetTypeKind
]

{ #category : #accessing }
MbndTypeKindConversionRule >> targetTypeKind: anObject [
	targetTypeKind := anObject
]
