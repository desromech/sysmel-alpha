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
		self
			addExplicitConversionRule: MbndPointerConstCastConversionRule new;
			addImplicitConversionRule: MbndPointerAddConstConversionRule new;
			addConversionTo: baseType withoutTopDecorations rule: MbndReferenceLoadTypeConversionRule.
		baseType withoutTopDecorations addConversionRulesToReferenceType: self
	]
]

{ #category : #initialization }
MbndReferenceType >> addInstanceMacros [
	self class == MbndReferenceType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #assignValue: do: [ :node :builder |
			(builder reference: node receiver assignValue: node arguments first)
				position: node
		];
		onMacroSelector: #basicInitialize do: [ :node :builder :analyzer |
			node receiver type baseType analyzeBasicInitializationNode: node with: analyzer
		];
		onMacroSelector: #address do: [ :node :builder |
			(builder referenceAsPointer: node receiver)
				position: node
		].
]

{ #category : #converting }
MbndReferenceType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| newExpression |
	newExpression := MbndAstReferenceLoadNode new
		position: node position;
		reference: node expression;
		type: baseType;
		yourself.
	^ analyzer visitNode: (node copy
		expression: newExpression;
		yourself)
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
MbndReferenceType >> asMutableValueType [
	^ self
]

{ #category : #converting }
MbndReferenceType >> asPointerType [
	^ baseType pointerFor: addressSpace
]

{ #category : #converting }
MbndReferenceType >> asReferenceType [
	^ self
]

{ #category : #'type composition' }
MbndReferenceType >> const [
	<compileTime>
	"References are always constants."
	^ self
]

{ #category : #'testing methods' }
MbndReferenceType >> isReferenceLikeValueType [
	^ true
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
MbndReferenceType >> ref [
	^ self
]

{ #category : #'type composition' }
MbndReferenceType >> withoutDecorations [
	^ baseType withoutDecorations refFor: addressSpace
]

{ #category : #'as yet unclassified' }
MbndReferenceType >> withoutReferences [
	^ baseType
]
