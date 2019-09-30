"
I am a MoebiusBand basic type that is not necesarily a Smalltalk Behavior.
"
Class {
	#name : #MbndBasicType,
	#superclass : #Object,
	#traits : 'TMbndBasicType',
	#classTraits : 'TMbndBasicType classTrait',
	#instVars : [
		'name',
		'parent',
		'children'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndBasicType class >> typeName [
	^ self == MbndBasicType ifTrue: [ #AnyValue ] ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
MbndBasicType >> addChild: aChild [
	self assert: aChild parent isNil.
	aChild parent: self.
	self children add: aChild.
]

{ #category : #initialization }
MbndBasicType >> addInstanceMacros [
	self class == MbndBasicType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #yourself do: [ :node :builder | node receiver ];
		onMacroSelector: #castTo: do: [ :node :builder |
			(builder explicitCast: node receiver to: node arguments first)
				position: node
		];
		onMacroSelector: #implicitCastTo: do: [ :node :builder |
			(builder implicitCast: node receiver to: node arguments first)
				position: node
		];
		onMacroSelector: #reinterpretCastTo: do: [ :node :builder |
			(builder reinterpretCast: node receiver to: node arguments first)
				position: node
		].
	
	self type
		onMacroSelector: #basicNewValue do: [ :node :builder :analyzer |
			node receiver type instanceType generateBasicNewValueForNode: node with: builder andWith: analyzer
		];
		onMacroSelector: #newValue do: [ :node :builder :analyzer |
			node receiver type instanceType generateNewValueForNode: node with: builder andWith: analyzer
		].
]

{ #category : #'as yet unclassified' }
MbndBasicType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #adding }
MbndBasicType >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #'semantic analysis' }
MbndBasicType >> enqueueDelayedSemanticAnalysis [
	self flag: 'TODO: Implement this properly.'
]

{ #category : #'as yet unclassified' }
MbndBasicType >> fullName [
	^ name ifNil: [ ^ self printString ]
]

{ #category : #initialization }
MbndBasicType >> generateBasicNewValueForNode: node with: builder andWith: analyzer [
	self isOpaqueType ifTrue: [
		self error: 'Cannot create a value with opaque type {1}' format: { self asString } at: node
	].

	^ self defaultValueASTNodeAt: node 
]

{ #category : #initialization }
MbndBasicType >> generateNewValueForNode: node with: builder andWith: analyzer [
	| basicValueNode |
	basicValueNode := self generateBasicNewValueForNode: node with: builder andWith: analyzer.
	^ self initializeAndReturnValueNode: basicValueNode with: builder andWith: analyzer.
]

{ #category : #initialization }
MbndBasicType >> initializeAndReturnValueNode: basicValueNode with: builder andWith: analyzer [
	self flag: 'TODO: Implement initializers.'.
	^ basicValueNode
]

{ #category : #initialization }
MbndBasicType >> initializeBasicTypeTrait [
	super initialize.
	name := self class typeName.
	flags := #(trait).
	self addInstanceMacros
]

{ #category : #initialization }
MbndBasicType >> initializeNonTraitType [
	flags ifNil: [ flags := #() ].
	self
		addDefaultConversionRules.
	self isTrait ifFalse: [
		self initialize
	].
	
]

{ #category : #accessing }
MbndBasicType >> name [
	^ name
]

{ #category : #accessing }
MbndBasicType >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
MbndBasicType >> parent [
	^ parent
]

{ #category : #accessing }
MbndBasicType >> parent: aParent [
	parent := aParent
]

{ #category : #printing }
MbndBasicType >> printOn: aStream [
	self name ifNotNil: [ :name |
		aStream nextPutAll: name
	] ifNil: [
		^ super printOn: aStream
	]
	
]
