Class {
	#name : #MbndLiteralScalarType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralScalarType class >> typeName [
	^ #_LiteralScalar
]

{ #category : #'testing methods' }
MbndLiteralScalarType >> isLiteralScalarType [
	^ true
]
