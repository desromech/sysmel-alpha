Class {
	#name : #SYMLTypeConversionRule,
	#superclass : #SYMLObject,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #testing }
SYMLTypeConversionRule >> canBeUsedToConvertFrom: sourceType into: targetType [
	self subclassResponsibility
]

{ #category : #testing }
SYMLTypeConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	^ self canBeUsedToConvertFrom: sourceType into: targetType
]

{ #category : #'as yet unclassified' }
SYMLTypeConversionRule >> convertSSAValue: rawValue to: targetType with: builder at: messageNode [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLTypeConversionRule >> intermediateConversion: intermediateType chainedWith: nextRule [
	^ SYMLChainedTypeConversionRule new
		intermediateType: intermediateType;
		intermediateRule: self;
		nextRule: nextRule;
		yourself
]

{ #category : #testing }
SYMLTypeConversionRule >> isTypeKindConversion [
	^ false
]
