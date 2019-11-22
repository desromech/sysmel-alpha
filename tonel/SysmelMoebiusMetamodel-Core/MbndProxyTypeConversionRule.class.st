Class {
	#name : #MbndProxyTypeConversionRule,
	#superclass : #MbndAbstractTypeConversionRule,
	#instVars : [
		'rule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndProxyTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ rule canBeUsedToConvertNode: node from: sourceType into: targetType
]

{ #category : #accessing }
MbndProxyTypeConversionRule >> conversionCost [
	^ rule conversionCost
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
