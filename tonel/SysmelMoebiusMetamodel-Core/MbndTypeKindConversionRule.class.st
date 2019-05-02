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
MbndTypeKindConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	targetType == targetTypeKind ifTrue: [ ^ true ].
	^ false
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
