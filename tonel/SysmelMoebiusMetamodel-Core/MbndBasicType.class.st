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
	#classVars : [
		'PerformMessageSelectors'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'class initialization' }
MbndBasicType class >> initialize [
	PerformMessageSelectors := #(
		#perform:
		#perform:with:
		#perform:with:with:
		#perform:with:with:with:
		#perform:with:with:with:with:
		#perform:with:with:with:with:with:
		#perform:with:with:with:with:with:with:
	)
]

{ #category : #accessing }
MbndBasicType class >> typeName [
	^ self == MbndBasicType ifTrue: [ #AnyValue ] ifFalse: [ nil ]
]

{ #category : #adding }
MbndBasicType >> addBuiltIn: selector intrinsicNamed: intrinsicName argumentTypes: argumentType returnType: returnType evaluatedWith: evaluationBlock [
	self addOverloadedMethod: (MbndTargetNamedIntrinsicMethod new
		name: selector;
		intrinsicName: intrinsicName;
		evaluationBlock: evaluationBlock;
		yourself)
		receiverType: self asReceiverType argumentTypes: argumentType returnType: returnType 
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
		onMacroSelector: #typeOfExpression do: [ :node :builder |
			((node receiver isLiteralValueNode
				ifTrue: [ node receiver value mbndLiteralTypeWithTarget: self compilationTarget ]
				ifFalse: [ node receiverType ])
				asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
				position: node
		];
		onMacroSelector: #selectCase: do: [ :node :builder |
			(builder casesOf: node receiver cases: node arguments first)
				position: node
		];
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
		];
		onMacroSelectors: PerformMessageSelectors do: [ :node :builder |
			node copy
				selector: node arguments first;
				arguments: node arguments allButFirst;
				yourself
		].
	self addMetaTypeMacrosTo: self type.
]

{ #category : #initialization }
MbndBasicType >> addMetaTypeMacrosTo: metaType [
	metaType
		onMacroSelectors: #( definition: extend: )do: [ :node :builder |
			builder programEntity: node receiver extension: node arguments first
		];
		onMacroSelector: #basicNewValue do: [ :node :builder :analyzer |
			analyzer analyzeNodeIfNeeded: (
				(node receiver isLiteralValueNode
					ifTrue: [ node receiver value unwrapMbndValue ]
					ifFalse: [ node receiver type instanceType ])
				 		generateBasicNewValueForNode: node with: builder andWith: analyzer
			)
		];
		onMacroSelector: #newValue do: [ :node :builder :analyzer |
			analyzer analyzeNodeIfNeeded: (
				(node receiver isLiteralValueNode
					ifTrue: [ node receiver value unwrapMbndValue ]
					ifFalse: [ node receiver type instanceType ])
						generateNewValueForNode: node with: builder andWith: analyzer
			)
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

{ #category : #'semantic analysis' }
MbndBasicType >> analyzeInitializationFromCopyNode: node with: analyzer [
	self hasTrivialInitializationCopyingFrom ifTrue: [
		^ analyzer visitNode: (node asUnexpandedMessageSend
			selector: ((analyzer astBuilder literalSymbol: #assignValue:)
				position: node))
	].
	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #adding }
MbndBasicType >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #'semantic analysis' }
MbndBasicType >> enqueueDelayedSemanticAnalysis [
	self module enqueueProgramEntityWithDelayedSemanticAnalysis: self
]

{ #category : #'semantic analysis' }
MbndBasicType >> ensureSemanticAnalysis [
	self isMetaType ifFalse: [
		self type ensureSemanticAnalysis
	].

	self ensureLookupMethodDictIsBuilt
]

{ #category : #'as yet unclassified' }
MbndBasicType >> ensureSyntheticMethodExists: aSelector [
	aSelector = #basicInitialize ifTrue: [^ self basicInitializeMethod ].
	aSelector = #initialize ifTrue: [^ self initializeMethod ].
	aSelector = #initializeCopyingFrom: ifTrue: [^ self initializeCopyingFromMethod ].
	aSelector = #initializeMovingFrom: ifTrue: [^ self initializeMovingFromMethod ].
	^ nil
]

{ #category : #converting }
MbndBasicType >> fillTypeInfoInstance: typeInfoInstance [
	typeInfoInstance
		setField: #instanceDataSize value: self instanceSize;
		setField: #instanceDataAlignment value: self instanceAlignment;
		setField: #basicInitializationFunctionPointer value: 
			(self hasTrivialBasicInitialization
				ifTrue: [ nil ]
				ifFalse: [ self basicInitializeMethod ]);
		setField: #copyConstructorFunctionPointer value: 
			(self hasTrivialInitializationCopyingFrom
				ifTrue: [ nil ]
				ifFalse: [ self initializeCopyingFromMethod ]);
		setField: #moveConstructorFunctionPointer value: 
			(self hasTrivialInitializationMovingFrom
				ifTrue: [ nil ]
				ifFalse: [ self initializeMovingFromMethod ])

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

	self isTypePassedByReference ifTrue: [
		^ builder temporaryVariableOfType: self
	].

	^ self defaultValueASTNodeAt: node 
]

{ #category : #initialization }
MbndBasicType >> generateNewValueForNode: node with: builder andWith: analyzer [
	| basicValueNode |
	basicValueNode := self generateBasicNewValueForNode: node with: builder andWith: analyzer.
	^ self initializeAndReturnValueNode: basicValueNode with: builder andWith: analyzer.
]

{ #category : #testing }
MbndBasicType >> hasTrivialInitializationCopyingFrom [
	^ self hasTrivialInstanceInitializationCopyingFrom
]

{ #category : #initialization }
MbndBasicType >> initializeAndReturnValueNode: basicValueNode with: builder andWith: analyzer [
	| analyzedBasicValueNode valueType |
	analyzedBasicValueNode := analyzer analyzeNodeIfNeeded: basicValueNode.
	valueType := analyzedBasicValueNode type withoutReferences.
	valueType hasTrivialInitialization ifTrue: [ ^ analyzedBasicValueNode ].

	basicValueNode isTemporaryVariableNode ifTrue: [
		^ basicValueNode withInitialization
	].
	
	^ (builder messageChainReceiver: analyzedBasicValueNode messages: {
		(builder messageChainMessageSelector: (builder literalSymbol: #initialize) arguments: #())
			position: analyzedBasicValueNode.
		(builder messageChainMessageSelector: (builder literalSymbol: #yourself) arguments: #())
			position: analyzedBasicValueNode.
	})
		position: analyzedBasicValueNode
]

{ #category : #initialization }
MbndBasicType >> initializeBasicTypeTrait [
	super initialize.
	name := self class typeName.
	flags := #().
	self markAsTrait.
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

{ #category : #'semantic analysis' }
MbndBasicType >> isDefined [
	^ self hasFlag: #defined
]

{ #category : #testing }
MbndBasicType >> isPOD [
	^ self hasTrivialBasicInitialization and: [
	  self hasTrivialInitialization and: [
	  self hasTrivialFinalization and: [
	  self hasTrivialInitializationCopyingFrom and: [
	  self hasTrivialInitializationMovingFrom ]]]]
]

{ #category : #testing }
MbndBasicType >> isPODInstance [
	^ self hasTrivialInstanceBasicInitialization and: [
	  self hasTrivialInstanceInitialization and: [
	  self hasTrivialInstanceFinalization and: [
	  self hasTrivialInstanceInitializationCopyingFrom and: [
	  self hasTrivialInstanceInitializationMovingFrom ]]]]
]

{ #category : #'as yet unclassified' }
MbndBasicType >> markAsDefined [
	self addFlag: #defined
]

{ #category : #initialization }
MbndBasicType >> markAsTrait [
	^ self addFlag: #trait
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
