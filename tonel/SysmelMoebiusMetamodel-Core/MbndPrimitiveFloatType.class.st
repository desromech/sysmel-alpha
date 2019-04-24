Class {
	#name : #MbndPrimitiveFloatType,
	#superclass : #MbndPrimitiveNumberType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType class >> typeName [
	^ #_PrimitiveFloatType
]

{ #category : #'default values' }
MbndPrimitiveFloatType >> defaultValue [
	^ MbndValue value: 0.0 type: self
]

{ #category : #testing }
MbndPrimitiveFloatType >> isAcceptableLiteralValue: literalValue [
	^ literalValue isNumber
]

{ #category : #'testing methods' }
MbndPrimitiveFloatType >> isPrimitiveFloatType [
	^ true
]

{ #category : #testing }
MbndPrimitiveFloatType >> legalizeLiteralValue: literalValue [
	^ literalValue asFloat
]
