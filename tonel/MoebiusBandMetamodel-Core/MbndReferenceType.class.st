Class {
	#name : #MbndReferenceType,
	#superclass : #MbndDerivedType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReferenceType class >> typeName [
	^ #_ReferenceType
]

{ #category : #'testing methods' }
MbndReferenceType >> isReferenceType [
	^ true
]
