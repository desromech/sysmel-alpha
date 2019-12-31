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

{ #category : #initialization }
MbndTemporaryReferenceType >> addInstanceMacros [
	self class == MbndTemporaryReferenceType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #asMoveReference do: [ :node :builder |
			node receiver
		]
]

{ #category : #'semantic analysis' }
MbndTemporaryReferenceType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndTemporaryReferenceType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndTemporaryReferenceType >> analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndTemporaryReferenceType >> asCVariadicTypeRequiredAt: position [
	^ baseType asCVariadicTypeRequiredAt: position
]

{ #category : #'semantic analysis' }
MbndTemporaryReferenceType >> asMutableValueType [
	^ baseType asMutableValueType
]

{ #category : #'semantic analysis' }
MbndTemporaryReferenceType >> asSuperArgumentType [
	^ self asReferenceType asSuperArgumentType
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

{ #category : #'type composition' }
MbndTemporaryReferenceType >> withoutDecorations [
	^ baseType withoutDecorations tempRefFor: addressSpace
]

{ #category : #'type composition' }
MbndTemporaryReferenceType >> withoutReferences [
	^ baseType
]
