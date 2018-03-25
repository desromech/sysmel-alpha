Class {
	#name : #SYMLLiteralNumberType,
	#superclass : #SYMLLiteralType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #coercion }
SYMLLiteralNumberType >> arithmeticCoerceWith: other [
	(ArithmeticCoercionTable coerce: self with: other) ifNotNil: [ :result | ^ result ].
	^ super arithmeticCoerceWith: other
]

{ #category : #testing }
SYMLLiteralNumberType >> canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition [
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
SYMLLiteralNumberType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ true
]

{ #category : #testing }
SYMLLiteralNumberType >> isNumberType [
	^ true
]

{ #category : #coercion }
SYMLLiteralNumberType >> ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition [
	targetType isIntegerType ifTrue: [ ^ SLVMConstant type: targetType ssaType value: value asInteger ].
	targetType isFloatType ifTrue: [ ^ SLVMConstant type: targetType ssaType value: value asFloat ].
	^ super ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
]
