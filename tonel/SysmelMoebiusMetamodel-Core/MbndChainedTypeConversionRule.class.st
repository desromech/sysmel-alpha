Class {
	#name : #MbndChainedTypeConversionRule,
	#superclass : #MbndAbstractTypeConversionRule,
	#instVars : [
		'intermediateType',
		'intermediateRule',
		'nextRule',
		'coercionCost'
	],
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #visiting }
MbndChainedTypeConversionRule >> accept: aVisitor [
	^ aVisitor visitChainedTypeConversionRule: self
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> coercionCost [
	^ coercionCost ifNil: [ coercionCost := intermediateRule coercionCost + nextRule coercionCost ]
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	| intermediateValue |
	intermediateValue := intermediateRule convertValue: value into: intermediateType at: coercionPosition.
	^ nextRule convertValue: intermediateValue into: targetType at: coercionPosition
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> intermediateRule [
	^ intermediateRule
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> intermediateRule: anObject [
	intermediateRule := anObject
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> intermediateType [
	^ intermediateType
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> intermediateType: anObject [
	intermediateType := anObject
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> nextRule [
	^ nextRule
]

{ #category : #accessing }
MbndChainedTypeConversionRule >> nextRule: anObject [
	nextRule := anObject
]

{ #category : #'as yet unclassified' }
MbndChainedTypeConversionRule >> postProcessCastNode: node [
	| intermediateCast nextCast |
	"Apply the intermediate cast."
	intermediateCast := node copy
		typeConversionRule: intermediateRule;
		type: intermediateType.
	intermediateCast := intermediateRule postProcessCastNode: intermediateCast.

	"Apply the next cast"	
	nextCast := node copy
		expression: intermediateCast;
		typeConversionRule: nextRule.
	^ nextCast postProcessCastNode: node.
]
