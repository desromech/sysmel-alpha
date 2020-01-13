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
			addImplicitConversionRule: MbndPointerAddConstConversionRule new.
		self addConversionRule: MbndToDerivedTypeConceptConversionRule new.
		baseType isPossibleToLoadReferences ifTrue: [
			self
				addConversionTo: baseType withoutTopDecorations rule: MbndReferenceLoadTypeConversionRule.
			baseType isConstantType ifTrue: [ 
				baseType baseType addConversionTo: self rule: MbndSpillValueInReferenceTypeConversionRule new.
			].
		].
		self addImplicitConversionRule: MbndClassImplicitUpcastTypeConversionRule new.
	]
]

{ #category : #initialization }
MbndReferenceType >> addInstanceMacros [
	self class == MbndReferenceType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #assignValue: do: [ :node :builder |
			(node receiver type baseType lookupOverloadedSelector: #assignValue:) ifNotNil: [
				node asExpandedMessageSend
			] ifNil: [ 
				(builder reference: node receiver assignValue: node arguments first)
					position: node
			]
		];
		onMacroSelector: #asMoveReference do: [ :node :builder |
			(builder reinterpretCast: node receiver to: node receiver type asTemporaryReferenceType)
				position: node
		];
		onMacroSelector: #basicInitialize do: [ :node :builder :analyzer |
			node receiver type baseType analyzeBasicInitializationNode: node with: analyzer
		];
		onMacroSelector: #initialize do: [ :node :builder :analyzer |
			node receiver type baseType analyzeInitializationNode: node with: analyzer
		];
		onMacroSelector: #initializeFromCopy: do: [ :node :builder :analyzer |
			node receiver type baseType analyzeInitializationFromCopyNode: node with: analyzer
		];
		onMacroSelector: #initializeMovingFrom: do: [ :node :builder :analyzer |
			node receiver type baseType analyzeInitializationMovingFromNode: node with: analyzer
		];
		onMacroSelector: #finalize do: [ :node :builder :analyzer |
			node receiver type baseType analyzeFinalizationNode: node with: analyzer
		];
		onMacroSelector: #address do: [ :node :builder |
			(builder referenceAsPointer: node receiver)
				position: node
		].
]

{ #category : #converting }
MbndReferenceType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| undecoratedTargetType newExpression |
	undecoratedTargetType := targetType withoutTopDecorations.
	(undecoratedTargetType isReferenceType or: [ undecoratedTargetType isTemporaryReferenceType ]) ifTrue: [
		^ analyzer visitNode: (MbndAstPointerReinterpretCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

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

{ #category : #'semantic analysis' }
MbndReferenceType >> analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #converting }
MbndReferenceType >> asCVariadicTypeRequiredAt: position [
	^ baseType asCVariadicTypeRequiredAt: position
]

{ #category : #converting }
MbndReferenceType >> asForwardingReferenceType [
	^ self
]

{ #category : #converting }
MbndReferenceType >> asMutableValueType [
	^ self
]

{ #category : #converting }
MbndReferenceType >> asReferenceType [
	^ self
]

{ #category : #converting }
MbndReferenceType >> asSuperArgumentType [
	^ baseType asSuperArgumentType refFor: addressSpace
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

{ #category : #testing }
MbndReferenceType >> pointerRank [
	^ baseType pointerRank , { {#reference . addressSpace . baseType isConstantType} }
]

{ #category : #printing }
MbndReferenceType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	baseType printOn: aStream.
	aStream nextPutAll: ' ref'
]

{ #category : #'type composition' }
MbndReferenceType >> refFor: anAddressSpace [
	addressSpace == anAddressSpace ifTrue: [ ^ self ].
	^ baseType refFor: anAddressSpace
]

{ #category : #'type composition' }
MbndReferenceType >> tempRefFor: anAddressSpace [
	addressSpace == anAddressSpace ifTrue: [ ^ self ].
	^ baseType refFor: anAddressSpace
]

{ #category : #'type composition' }
MbndReferenceType >> withoutDecorations [
	^ baseType withoutDecorations refFor: addressSpace
]

{ #category : #'as yet unclassified' }
MbndReferenceType >> withoutReferences [
	^ baseType
]
