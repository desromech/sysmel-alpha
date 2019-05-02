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

{ #category : #visiting }
MbndAbstractTypeConversionRule >> accept: aVisitor [
	self subclassResponsibility
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
	self subclassResponsibility
]

{ #category : #testing }
MbndAbstractTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ self canBeUsedToConvertFrom: sourceType into: targetType
]

{ #category : #acccessing }
MbndAbstractTypeConversionRule >> conversionCost [
	self subclassResponsibility
]

{ #category : #converting }
MbndAbstractTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	self subclassResponsibility
]

{ #category : #testing }
MbndAbstractTypeConversionRule >> isTypeKindConversion [
	^ false
]

{ #category : #'as yet unclassified' }
MbndAbstractTypeConversionRule >> postProcessCastNode: node [
	^ node
]

{ #category : #scripting }
MbndAbstractTypeConversionRule >> when: aPredicate [
	^ MbndPredicatedTypeConversionRule new
		rule: self;
		predicate: aPredicate;
		yourself
]
