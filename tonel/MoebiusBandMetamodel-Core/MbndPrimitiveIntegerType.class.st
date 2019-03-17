Class {
	#name : #MbndPrimitiveIntegerType,
	#superclass : #MbndPrimitiveType,
	#instVars : [
		'signed'
	],
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'testing methods' }
MbndPrimitiveIntegerType >> isPrimitiveIntegerType [
	^ true
]

{ #category : #'testing methods' }
MbndPrimitiveIntegerType >> isSigned [
	^ signed
]

{ #category : #'testing methods' }
MbndPrimitiveIntegerType >> isUnsigned [
	^ signed not
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed [
	^ signed
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed: anObject [
	signed := anObject
]
