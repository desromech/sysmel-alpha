Class {
	#name : #MbndReferenceType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReferenceType class >> typeName [
	^ #_ReferenceType
]

{ #category : #'testing methods' }
MbndReferenceType >> isReferenceType [
	^ true
]

{ #category : #printing }
MbndReferenceType >> printOn: aStream [
	baseType printOn: aStream.
	aStream nextPutAll: ' ref'
]
