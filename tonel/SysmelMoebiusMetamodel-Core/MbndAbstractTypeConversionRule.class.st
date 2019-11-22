Class {
	#name : #MbndAbstractTypeConversionRule,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #converting }
MbndAbstractTypeConversionRule class >> asMbndTypeConversionRuleTo: targetType [
	^ self new asMbndTypeConversionRuleTo: targetType
]

{ #category : #scripting }
MbndAbstractTypeConversionRule class >> when: aPredicate [
	^ self new when: aPredicate
]

{ #category : #converting }
MbndAbstractTypeConversionRule >> asMbndTypeConversionRuleTo: targetType [
	^ MbndTypeKindConversionRule new
		rule: self;
		targetTypeKind: targetType;
		yourself
]

{ #category : #testing }
MbndAbstractTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	^ self canBeUsedToConvertNode: MbndAstNode dummy from: sourceType into: targetType
]

{ #category : #testing }
MbndAbstractTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ self subclassResponsibility
]

{ #category : #acccessing }
MbndAbstractTypeConversionRule >> conversionCost [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MbndAbstractTypeConversionRule >> intermediateConversion: intermediateType chainedWith: nextRule [
	^ MbndChainedTypeConversionRule new
		intermediateType: intermediateType;
		intermediateRule: self;
		nextRule: nextRule;
		yourself
]

{ #category : #testing }
MbndAbstractTypeConversionRule >> isTypeKindConversion [
	^ false
]

{ #category : #'as yet unclassified' }
MbndAbstractTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	"TODO: In some of these cases, we may need to make this an upcast explicit."
	^ node expression
]

{ #category : #scripting }
MbndAbstractTypeConversionRule >> when: aPredicate [
	^ MbndPredicatedTypeConversionRule new
		rule: self;
		predicate: aPredicate;
		yourself
]
