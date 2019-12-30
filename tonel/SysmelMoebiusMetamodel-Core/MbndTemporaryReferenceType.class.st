Class {
	#name : #MbndTemporaryReferenceType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTemporaryReferenceType class >> typeName [
	^ #_TemporaryReferenceType
]

{ #category : #visiting }
MbndTemporaryReferenceType >> accept: aVisitor [
	^ aVisitor visitTemporaryReferenceType: self
]

{ #category : #converting }
MbndTemporaryReferenceType >> asTemporaryReferenceType [
	^ self
]

{ #category : #'type composition' }
MbndTemporaryReferenceType >> const [
	^ self
]

{ #category : #'testing methods' }
MbndTemporaryReferenceType >> isReferenceLikeValueType [
	^ true
]

{ #category : #testing }
MbndTemporaryReferenceType >> isTemporaryReferenceType [
	^ true
]

{ #category : #printing }
MbndTemporaryReferenceType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	baseType printOn: aStream.
	aStream nextPutAll: ' tempRef'
]

{ #category : #'type composition' }
MbndTemporaryReferenceType >> ref [
	^ baseType refFor: addressSpace
]

{ #category : #'type composition' }
MbndTemporaryReferenceType >> tempRef [
	^ self
]
