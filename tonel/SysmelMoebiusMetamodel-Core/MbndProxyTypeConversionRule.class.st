Class {
	#name : #MbndProxyTypeConversionRule,
	#superclass : #MbndAbstractTypeConversionRule,
	#instVars : [
		'rule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndProxyTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ rule canBeUsedToConvertFrom: sourceType into: targetType
]

{ #category : #accessing }
MbndProxyTypeConversionRule >> conversionCost [
	^ rule coercionCost
]

{ #category : #'as yet unclassified' }
MbndProxyTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	^ rule postProcessCastNode: node withAnalyzer: analyzer
]

{ #category : #accessing }
MbndProxyTypeConversionRule >> rule [
	^ rule
]

{ #category : #accessing }
MbndProxyTypeConversionRule >> rule: anObject [
	rule := anObject
]
