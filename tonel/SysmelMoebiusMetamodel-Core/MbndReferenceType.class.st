Class {
	#name : #MbndReferenceType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReferenceType class >> typeName [
	^ #_ReferenceType
]

{ #category : #'semantic analysis' }
MbndReferenceType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndReferenceType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeUnexpandedMessageSendNode: node with: analyzer
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

{ #category : #'type composition' }
MbndReferenceType >> withoutDecorations [
	^ baseType withoutDecorations refFor: addressSpace
]

{ #category : #'as yet unclassified' }
MbndReferenceType >> withoutReferences [
	^ baseType
]
