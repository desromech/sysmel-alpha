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
	self type macroMethodDict at: selector put: accessor.
	accessor parent: self
]

{ #category : #'semantic analysis' }
TMbndBasicType >> analyzeInitializationFromCopyNode: node with: analyzer [
	self hasTrivialInitializationCopyingFrom ifTrue: [
		^ analyzer visitNode: (node asUnexpandedMessageSend
			selector: ((analyzer astBuilder literalSymbol: #assignValue:)
				position: node))
	].
	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #'as yet unclassified' }
TMbndBasicType >> ensureSyntheticMethodExists: aSelector [
	self isImported ifTrue: [ ^ nil ].
	self isTrait ifTrue: [ ^ nil ].
	aSelector = #basicInitialize ifTrue: [^ self basicInitializeMethod ].
	aSelector = #initialize ifTrue: [^ self initializeMethod ].
	aSelector = #initializeCopyingFrom: ifTrue: [^ self initializeCopyingFromMethod ].
	aSelector = #initializeMovingFrom: ifTrue: [^ self initializeMovingFromMethod ].
	aSelector = #finalize ifTrue: [^ self finalizeMethod ].
	aSelector = #assignValue: ifTrue: [
		self hasTrivialCopyAssignment ifFalse: [ self copyAssignmentMethod ].
		self hasTrivialMoveAssignment ifFalse: [ self moveAssignmentMethod ].
		^ self
	].

	^ nil
]

{ #category : #'type hierarchy' }
TMbndBasicType >> evaluateSuperTypePendingDefinitionFragments [
	
]

{ #category : #testing }
TMbndBasicType >> hasPublicVisibility [
	^ self visibilityMode == #public
]

{ #category : #testing }
TMbndBasicType >> hasTrivialInitializationCopyingFrom [
	^ self hasTrivialInstanceInitializationCopyingFrom
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

{ #category : #testing }
TMbndBasicType >> isPODInstance [
	^ self hasTrivialInstanceBasicInitialization and: [
	  self hasTrivialInstanceInitialization and: [
	  self hasTrivialInstanceFinalization and: [
	  self hasTrivialInstanceInitializationCopyingFrom and: [
	  self hasTrivialInstanceInitializationMovingFrom ]]]]
]

{ #category : #methods }
TMbndBasicType >> lookupLocalOverloadedSelector: aSelector [
	^ self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupOverloadedSelector: aSelector [
	| method |
	self evaluatePendingDefinitionFragmentsForOverloadedSelector: aSelector.
	
	(#(basicInitialize initialize initializeCopyingFrom: initializeMovingFrom: finalize assignValue:) includes: aSelector) ifTrue: [
		self ensureSyntheticMethodExists: aSelector
	].
	method := self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupOverloadedSelector: aSelector ]
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupSelector: aSelector [
	| method |
	method := self methodDict at: aSelector ifAbsent: [
		self evaluateAllPendingDefinitionFragments.
		self methodDict at: aSelector ifAbsent: [ nil ]
	].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupSelector: aSelector ]
]

{ #category : #'member symbols' }
TMbndBasicType >> lookupSymbol: aSymbol [
	(self lookupSpecialSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	(self lookupLocalSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	^ self supertype ifNotNil: [ :st | st lookupSymbol: aSymbol ]
]

{ #category : #'as yet unclassified' }
TMbndBasicType >> programEntitionInformationData [
	^ self programEntityInformationData
]

{ #category : #initialization }
TMbndBasicType >> setSupertypeFromDefinition: newSupertype [
	self supertype: newSupertype.
	self type supertype: newSupertype type.
]

{ #category : #'type hierarchy' }
TMbndBasicType >> supertype [
	self evaluateSuperTypePendingDefinitionFragments.
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
	self isMetaType ifTrue: [ 
		self evaluateSuperTypePendingDefinitionFragments.
	].
	^ type
]

{ #category : #accessing }
TMbndBasicType >> type: aType [
	type := aType
]
