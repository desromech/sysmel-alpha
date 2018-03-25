Class {
	#name : #SYMLLiteralFloatType,
	#superclass : #SYMLLiteralNumberType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'meta evaluation' }
SYMLLiteralFloatType >> concreteTypeForNode: aNode [
	self flag: 'TODO: Check the actual range of the value to choose between int32 and int64.'.
	^ target float64Type
]

{ #category : #testing }
SYMLLiteralFloatType >> isFloatType [
	^ true
]

{ #category : #accessing }
SYMLLiteralFloatType >> name [
	^ #_LiteralFloat
]

{ #category : #arithmetic }
SYMLLiteralFloatType >> resultTypeForArithmeticMessage: selector at: node [
	(ArithmeticSelectors includes: selector) ifTrue: [ ^ self ].
	(ComparisonSelectors includes: selector) ifTrue: [ ^ target booleanType ].
	^ super resultTypeForArithmeticMessage: selector at: node
]

{ #category : #coercion }
SYMLLiteralFloatType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	^ builder constDouble: value asFloat
]
