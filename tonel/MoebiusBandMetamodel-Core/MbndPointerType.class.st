Class {
	#name : #MbndPointerType,
	#superclass : #MbndDerivedType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPointerType class >> typeName [
	^ #_PointerType
]

{ #category : #'testing methods' }
MbndPointerType >> isPointerType [
	^ true
]
