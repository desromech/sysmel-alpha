Class {
	#name : #SYMLFloatType,
	#superclass : #SYMLPrimitiveNumberType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLFloatType >> isFloatType [
	^ true
]

{ #category : #arithmetic }
SYMLFloatType >> resultTypeForArithmeticMessage: selector at: node [
	(ArithmeticSelectors includes: selector) ifTrue: [ ^ self ].
	(ComparisonSelectors includes: selector) ifTrue: [ ^ target booleanType ].
	^ super resultTypeForArithmeticMessage: selector at: node
]

{ #category : #coercion }
SYMLFloatType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	self size >= 8 ifTrue: [ ^ value ].
	^ builder floatingPointCast: value target: builder compilationTarget double
]
