Trait {
	#name : #TMbndBasicType,
	#instVars : [
		'supertype',
		'type'
	],
	#traits : 'TMbndType + TMbndMethodContainer + TMbndFlagContainer + TMbndSymbolContainer + TMbndEntityWithVisibility',
	#classTraits : 'TMbndType classTrait + TMbndMethodContainer classTrait + TMbndFlagContainer classTrait + TMbndSymbolContainer classTrait + TMbndEntityWithVisibility classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
TMbndBasicType >> addStaticAccessor: accessor for: selector [
	self type macroMethodDict at: selector put: accessor
]

{ #category : #'as yet unclassified' }
TMbndBasicType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #'as yet unclassified' }
TMbndBasicType >> ensureSyntheticMethodExists: aSelector [
	aSelector = #basicInitialize ifTrue: [^ self basicInitializeMethod ].
	aSelector = #initialize ifTrue: [^ self initializeMethod ].
	aSelector = #initializeFrom: ifTrue: [^ self initializeFromCopyMethod ].
	aSelector = #initializeMovingFrom: ifTrue: [^ self initializeMovingFromMethod ].
	^ nil
]

{ #category : #testing }
TMbndBasicType >> hasPublicVisibility [
	^ self visibilityMode == #public
]

{ #category : #'as yet unclassified' }
TMbndBasicType >> implicitFunctionConstReceiverType [
	^ self asConstReceiverType
]

{ #category : #'as yet unclassified' }
TMbndBasicType >> implicitMethodConstReceiverType [
	^ self asConstReceiverType
]

{ #category : #'as yet unclassified' }
TMbndBasicType >> implicitMethodReceiverType [
	^ self asReceiverType
]

{ #category : #methods }
TMbndBasicType >> lookupLocalOverloadedSelector: aSelector [
	^ self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupOverloadedSelector: aSelector [
	| method |
	(#(basicInitialize initialize initializeFromCopy: initializeMovingFrom: finalize) includes: aSelector) ifTrue: [
		self ensureSyntheticMethodExists: aSelector
	].
	method := self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupOverloadedSelector: aSelector ]
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupSelector: aSelector [
	| method |
	method := self methodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupSelector: aSelector ]
]

{ #category : #'member symbols' }
TMbndBasicType >> lookupSymbol: aSymbol [
	(self lookupSpecialSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	(self lookupLocalSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	^ self supertype ifNotNil: [ :st | st lookupSymbol: aSymbol ]
]

{ #category : #initialization }
TMbndBasicType >> setSupertypeFromDefinition: newSupertype [
	self supertype: newSupertype.
	self type supertype: newSupertype type.
]

{ #category : #'type hierarchy' }
TMbndBasicType >> supertype [
	^ supertype
]

{ #category : #accessing }
TMbndBasicType >> supertype: aType [
	<compileTime>
	self assert: aType ~~ self.
	supertype ifNotNil: [
		supertype subtypeRemoved: self
	].

	supertype := aType.
	
	self isMetaType ifFalse: [
		type ifNotNil: [ 
			type type: supertype type type
		].
	].
	
	supertype ifNotNil: [
		supertype subtypeAdded: self
	].

]

{ #category : #'type hierarchy' }
TMbndBasicType >> type [
	<compileTime>
	^ type
]

{ #category : #accessing }
TMbndBasicType >> type: aType [
	type := aType
]
