Class {
	#name : #SYMLLiteralIntegerType,
	#superclass : #SYMLLiteralNumberType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #coercion }
SYMLLiteralIntegerType >> canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition [
	| literalValue |
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	targetType isLiteralType ifFalse: [
		node ifNotNil: [ 
			literalValue := node value value.
			targetType isIntegerType ifTrue: [
				(targetType isUnsigned and: [literalValue < 0]) ifTrue: [ 
					^ false
				]
			]
		].
	].

	targetType isNumberType ifTrue: [ ^ true ].
	^ false
]

{ #category : #'meta evaluation' }
SYMLLiteralIntegerType >> concreteTypeForNode: aNode [
	self flag: 'TODO: Check the actual range of the value to choose between int32 and int64.'.
	^ target int32Type
]

{ #category : #testing }
SYMLLiteralIntegerType >> isIntegerType [
	^ true
]

{ #category : #accessing }
SYMLLiteralIntegerType >> name [
	^ #_LiteralInteger
]

{ #category : #arithmetic }
SYMLLiteralIntegerType >> resultTypeForArithmeticMessage: selector at: node [
	(ArithmeticSelectors includes: selector) ifTrue: [ ^ self ].
	(BitwiseSelectors includes: selector) ifTrue: [ ^ self ].
	(ComparisonSelectors includes: selector) ifTrue: [ ^ target booleanType ].
	^ super resultTypeForArithmeticMessage: selector at: node
]

{ #category : #coercion }
SYMLLiteralIntegerType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	^ builder constInt: value asInteger
]
