Class {
	#name : #MbndPointerType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPointerType class >> typeName [
	^ #_PointerType
]

{ #category : #'default values' }
MbndPointerType >> defaultValue [
	^ MbndValue value: nil type: self
]

{ #category : #'testing methods' }
MbndPointerType >> isPointerType [
	^ true
]

{ #category : #printing }
MbndPointerType >> printOn: aStream [
	baseType printOn: aStream.
	aStream nextPutAll: ' pointer'
]

{ #category : #'type composition' }
MbndPointerType >> withoutDecorations [
	^ baseType withoutDecorations pointerFor: addressSpace
]
