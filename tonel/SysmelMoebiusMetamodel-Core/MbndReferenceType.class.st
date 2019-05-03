Class {
	#name : #MbndReferenceType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReferenceType class >> typeName [
	^ #_ReferenceType
]

{ #category : #visiting }
MbndReferenceType >> accept: aVisitor [
	^ aVisitor visitReferenceType: self
]

{ #category : #adding }
MbndReferenceType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	baseType ifNotNil: [ 
		self addConversionTo: baseType withoutTopDecorations rule: MbndReferenceLoadTypeConversionRule.
	]
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

{ #category : #converting }
MbndReferenceType >> asCVariadicTypeRequiredAt: position [
	^ baseType asCVariadicTypeRequiredAt: position
]

{ #category : #converting }
MbndReferenceType >> asPointerType [
	^ baseType pointerFor: addressSpace
]

{ #category : #converting }
MbndReferenceType >> asReferenceType [
	^ self
]

{ #category : #initialization }
MbndReferenceType >> initializeBasicTypeTrait [
	super initializeBasicTypeTrait.
	self
		onMacroSelector: #assignValue: do: [ :node :builder |
			(builder reference: node receiver assignValue: node arguments first)
				position: node
		];
		onMacroSelector: #address do: [ :node :builder |
			(builder referenceAsPointer: node receiver)
				position: node
		].
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
