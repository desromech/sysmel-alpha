Class {
	#name : #MbndChainedTypeConversionRule,
	#superclass : #MbndAbstractTypeConversionRule,
	#instVars : [
		'intermediateType',
		'intermediateRule',
		'nextRule',
		'conversionCost'
	],
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #accessing }
MbndChainedTypeConversionRule >> conversionCost [
	^ conversionCost ifNil: [ conversionCost := intermediateRule conversionCost + nextRule conversionCost ]
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
MbndChainedTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| intermediateCast nextCast |

	"Apply the intermediate cast."
	intermediateCast := node copy
		typeConversionRule: intermediateRule;
		type: intermediateType.
	intermediateCast := intermediateRule postProcessCastNode: intermediateCast withAnalyzer: analyzer.

	"Apply the next cast"	
	nextCast := node copy
		expression: intermediateCast;
		typeConversionRule: nextRule.
	^ nextRule postProcessCastNode: nextCast withAnalyzer: analyzer.
]
