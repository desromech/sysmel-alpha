Class {
	#name : #MbndDerivedType,
	#superclass : #MbndNativeType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDerivedType class >> typeName [
	^ #_DerivedType
]

{ #category : #'testing methods' }
MbndDerivedType >> isDerivedType [
	^ true
]
