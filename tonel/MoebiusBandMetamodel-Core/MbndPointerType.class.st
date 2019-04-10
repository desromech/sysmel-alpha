Class {
	#name : #MbndPointerType,
	#superclass : #MbndPointerLikeType,
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
