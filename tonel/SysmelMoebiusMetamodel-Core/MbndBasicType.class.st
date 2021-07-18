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
		'category',
		'parent',
		'children',
		'pendingDefinitionFragments'
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

{ #category : #serialization }
MbndBasicType class >> makeInstanceForMessagePackGraphMaterializationWith: graphDecoder [
	^ self basicNew
]

{ #category : #serialization }
MbndBasicType class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	objectType == #CoreBasicType ifTrue: [
		| fields basicType|
		fields := Dictionary newFromPairs: graphDecoder decodeNext.
		basicType := graphDecoder compilationTarget getBasicTypeNamed: (fields at: #name).
		graphDecoder registerObjectInstance: basicType.
		^ basicType
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

{ #category : #serialization }
MbndBasicType class >> messagePackTypeName [
	self assert: (self name beginsWith: 'Mbnd').
	^ (self name allButFirst: 'Mbnd' size) asSymbol
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

{ #category : #adding }
MbndBasicType >> addCustomConstructorMethod: method [
	
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
		onMacroSelector: #asPatternMatchingPattern do: [ :node :builder :analyzer |
			node receiver type analyzeValueAsPatternMatchingPattern: node receiver with: analyzer
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
		onMacroSelector: #applyWithArguments: do: [ :node :builder :analyzer |
			(node receiver isLiteralValueNode
					ifTrue: [ node receiver value unwrapMbndValue ]
					ifFalse: [ node receiver type instanceType ])
				analyzeConstructionWithArguments: node arguments first at: node with: analyzer
		];
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

{ #category : #adding }
MbndBasicType >> addPendingDefinitionFragment: pendingDefinitionFragment [
	(self isCoreBasicType or: [ self isMetaType and: [ self instanceType isNotNil and: [self instanceType isCoreBasicType] ] ]) ifTrue: [ 
		pendingDefinitionFragment evaluate
	] ifFalse: [
		self pendingDefinitionFragments add: pendingDefinitionFragment.
		pendingDefinitionFragment module == self module ifTrue: [
			self enqueueDelayedSemanticAnalysis
		] ifFalse: [
			pendingDefinitionFragment module recordEntityWithPendingDefinitionFragments: self
		]
	].
]

{ #category : #'semantic analysis' }
MbndBasicType >> analyzeConstructionWithArguments: argumentsTupleNode at: position with: analyzer [
	| constructorGroup callNode |
	(analyzer isEmptyTupleNode: argumentsTupleNode) ifTrue: [ 
		^ analyzer analyzeNodeIfNeeded: (self generateNewValueForNode: position with: analyzer astBuilder andWith: analyzer)
	].

	constructorGroup := self type constructorGroup.
	constructorGroup ifNotNil: [
		callNode := MbndAstFunctionCallNode new
			position: position;
			function: (constructorGroup analyzeReferenceNode: position with: analyzer);
			arguments: argumentsTupleNode;
			yourself.
		^ analyzer visitNode: callNode
	].

	self error: 'Custom constructor are not avaiable for type {1}.' format: {  self asString } at: position
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

{ #category : #testing }
MbndBasicType >> analyzePragmaInDefinitionBodyWithSelector: selector arguments: arguments [
	(#(gpu) includes: selector) ifTrue: [ 
		self addFlag: selector
	].
]

{ #category : #'as yet unclassified' }
MbndBasicType >> analyzeReferenceAssignmentNode: node with: analyzer [
	| newValue |
	newValue := node value.
	
	newValue isTemporaryReferenceLoadNode ifTrue: [ 
		(newValue type isNonMoveable and: [ newValue type isNonCopyable ]) ifTrue: [
			self error: 'Cannot assign into a variable with a non-moveable and non-copyable value type "{1}".' format: { newValue type asString } at: node
		].
	] ifFalse: [ 
		newValue type isNonCopyable ifTrue: [
			self error: 'Cannot assign into a variable with a non-copyable value type "{1}".' format: { newValue type asString } at: node
		].
	].
	
	"By default, just add an implicit cast to the assigned value."
	^ node copy value: (analyzer addImplicitCastFor: node value to: self).
	
]

{ #category : #initialization }
MbndBasicType >> analyzeValueAsPatternMatchingPattern: node with: analyzer [
	^ analyzer visitNode: (MbndAstPatternMatchingSameValuePatternNode new
		expectedValue: node;
		yourself)
]

{ #category : #converting }
MbndBasicType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget dynamicObjectType ifNil: [ self ]
]

{ #category : #accessing }
MbndBasicType >> category [
	^ category
]

{ #category : #accessing }
MbndBasicType >> category: anObject [
	category := anObject
]

{ #category : #adding }
MbndBasicType >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #accessing }
MbndBasicType >> compilationEnvironment [
	^ self module compilationEnvironment
]

{ #category : #serialization }
MbndBasicType >> encodeFieldsForMessagePackWith: graphEncoder [
	graphEncoder recordType: self lazyFields: (self encodeLazyFieldsForMessagePackWith: graphEncoder).
	^ { 
		#flags . flags.
		#name . name.
		#category . category.
		#definitionModule . definitionModule encodeGraphForMessagePackWith: graphEncoder.
		#supertype . supertype encodeGraphForMessagePackWith: graphEncoder.
		#poolDictionaries . poolDictionaries encodeGraphForMessagePackWith: graphEncoder.
		#usedTraits . usedTraits encodeGraphForMessagePackWith: graphEncoder.
		#type . type encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #serialization }
MbndBasicType >> encodeGraphForMessagePackWith: graphEncoder [
	self isCoreBasicType ifTrue: [ 
		^ graphEncoder encodeObject: self type: #CoreBasicType fields: [
			self assert: name isNotNil.
			self assert: (self compilationTarget getBasicTypeNamed: name) == self.

			{#name . name}
		]
	].

	self isSystemProvidedTypeTemplateInstanceMainChild ifTrue: [
		^ graphEncoder encodeObject: self type: #SystemProvidedTypeTemplateInstanceMainChild fields: [
			self assert: parent isSystemProvidedTypeTemplateInstance.
			self assert: parent parent isSystemProvidedTypeTemplate.
			self assert: (self compilationTarget getBasicTypeNamed: parent parent name) == parent parent.

			{#systemTypeTemplate . parent parent name.
			 #instanceArguments . parent instanceArguments collect: [:each | each encodeGraphForMessagePackWith: graphEncoder]}
		]
	].

	(graphEncoder encodeExternalProgramEntityReferenceFor: self) ifNotNil: [ :ref | ^ ref ].

	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [self encodeFieldsForMessagePackWith: graphEncoder]
]

{ #category : #serialization }
MbndBasicType >> encodeLazyFieldsForMessagePackWith: graphEncoder [
	^ {
		#macroMethodDict . graphEncoder encodeSymbolTable: macroMethodDict.
		#methodDict . graphEncoder encodeSymbolTable: methodDict.
		#overloadedMethodDict . graphEncoder encodeSymbolTable: overloadedMethodDict.
		#localSymbolTable . graphEncoder encodeSymbolTable: localSymbolTable.
		#children . graphEncoder encodeProgramEntityList: children
	}
]

{ #category : #'semantic analysis' }
MbndBasicType >> enqueueDelayedSemanticAnalysis [
	self module enqueueProgramEntityWithDelayedSemanticAnalysis: self
]

{ #category : #'as yet unclassified' }
MbndBasicType >> ensureRingDefinitionIn: aRGEnvironment [
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
	^ aRGEnvironment backend definitionFor: self ifAbsentRegister: [
		self buildRingDefinitionFor: aRGEnvironment
	]
]

{ #category : #'semantic analysis' }
MbndBasicType >> ensureSemanticAnalysis [
	self evaluateAllPendingDefinitionFragments.
	self isMetaType ifFalse: [
		self type ensureSemanticAnalysis
	].

	self flag: 'TODO: try to remove this ensure lookup method dict is built call if possible'.
	self ensureLookupMethodDictIsBuilt
]

{ #category : #'as yet unclassified' }
MbndBasicType >> evaluateAllPendingDefinitionFragments [
	| toEvaluate |
	self isStrictMetaType ifTrue: [ 
		self instanceType ifNotNil: [:it | it evaluateAllPendingDefinitionFragments ]
	].

	(pendingDefinitionFragments isNil or: [pendingDefinitionFragments isEmpty]) ifTrue: [ ^ self ].
	toEvaluate := pendingDefinitionFragments asArray.
	pendingDefinitionFragments removeAll.
	toEvaluate do: [ :each | each evaluate ]
]

{ #category : #'as yet unclassified' }
MbndBasicType >> evaluateAllPendingDefinitionFragmentsThat: aBlock [
	| toEvaluate |
	self isStrictMetaType ifTrue: [ 
		self instanceType ifNotNil: [:it | it evaluateAllPendingDefinitionFragmentsThat: aBlock ]
	].

	(pendingDefinitionFragments isNil or: [pendingDefinitionFragments isEmpty]) ifTrue: [ ^ self ].
	toEvaluate := pendingDefinitionFragments select: aBlock.
	pendingDefinitionFragments := pendingDefinitionFragments reject: aBlock.
	toEvaluate do: [ :each | each evaluate ]
]

{ #category : #'type hierarchy' }
MbndBasicType >> evaluateSuperTypePendingDefinitionFragments [
	self evaluateAllPendingDefinitionFragmentsThat: [ :each | each isSupertypeDefinition ]
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
MbndBasicType >> hasBasicRequiredRTTI [
	^ (self hasFlag: #requiredBasicRTTI) or: [
			self supertype ifNil: [ false] ifNotNil: [:st | st hasBasicRequiredRTTI ] ]
]

{ #category : #testing }
MbndBasicType >> hasMethodDictionaryRequired [
	^ (self hasFlag: #methodDictionaryRequired) or: [
			self supertype ifNil: [ false] ifNotNil: [:st | st hasMethodDictionaryRequired ] ]
]

{ #category : #testing }
MbndBasicType >> hasRequiredRTTI [
	^ (self hasFlag: #requiredRTTI) or: [
			self supertype ifNil: [ false] ifNotNil: [:st | st hasRequiredRTTI ] ]
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
	flags ifNil: [ flags := #() ].
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

{ #category : #testing }
MbndBasicType >> isCoreBasicType [
	^ self hasFlag: #coreBasicType
]

{ #category : #'semantic analysis' }
MbndBasicType >> isDefined [
	^ self hasFlag: #defined
]

{ #category : #testing }
MbndBasicType >> isImported [
	^ self hasFlag: #imported
]

{ #category : #testing }
MbndBasicType >> isPODInstance [
	^ self hasTrivialInstanceBasicInitialization and: [
	  self hasTrivialInstanceInitialization and: [
	  self hasTrivialInstanceFinalization and: [
	  self hasTrivialInstanceInitializationCopyingFrom and: [
	  self hasTrivialInstanceInitializationMovingFrom ]]]]
]

{ #category : #testing }
MbndBasicType >> isSealed [
	^ self hasFlag: #sealed
]

{ #category : #'as yet unclassified' }
MbndBasicType >> isSystemProvidedTypeTemplateInstanceMainChild [
	^ parent isNotNil and: [ parent isSystemProvidedTypeTemplateInstance ]
]

{ #category : #'as yet unclassified' }
MbndBasicType >> markAsDefined [
	self addFlag: #defined
]

{ #category : #initialization }
MbndBasicType >> markAsTrait [
	^ self addFlag: #trait
]

{ #category : #serialization }
MbndBasicType >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	flags := encodedFields at: #flags.
	definitionModule := encodedFields at: #definitionModule.
	name := encodedFields at: #name ifAbsent: [ nil ].
	category := encodedFields at: #category ifAbsent: [ nil ].
	supertype := encodedFields at: #supertype ifAbsent: [ nil ].
	type := encodedFields at: #type ifAbsent: [ nil ].
	self addFlag: #imported.
]

{ #category : #serialization }
MbndBasicType >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	macroMethodDict := Dictionary newFromPairs: (encodedFields at: #macroMethodDict).
	methodDict := Dictionary newFromPairs: (encodedFields at: #methodDict).
	overloadedMethodDict := Dictionary newFromPairs: (encodedFields at: #overloadedMethodDict).
	localSymbolTable := Dictionary newFromPairs: (encodedFields at: #localSymbolTable).
	children := 	(encodedFields at: #children ifAbsent: [ #() ]) asOrderedCollection
]

{ #category : #serialization }
MbndBasicType >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #testing }
MbndBasicType >> mustBeAvailableInTheGPU [
	^ self hasFlag: #gpu
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

{ #category : #accessing }
MbndBasicType >> pendingDefinitionFragments [
	^ pendingDefinitionFragments ifNil: [ pendingDefinitionFragments := OrderedCollection new ]
]

{ #category : #accessing }
MbndBasicType >> postMaterializeSetupParent: newParent withModule: newModule [
	self parent: newParent.
	self addDefaultConversionRules.
	self isStrictMetaType ifFalse: [ 
		self type postMaterializeSetupParent: nil withModule: newModule.
		self assert: self type module == newModule.
	] ifTrue: [
		self assert: self instanceType module == newModule.
	].
	
	self childrenDo: [ :child |
		child postMaterializeSetupParent: self withModule: newModule
	].
	
]

{ #category : #'as yet unclassified' }
MbndBasicType >> printOn: aStream [
	aStream nextPutAll: self qualifiedName
]

{ #category : #'as yet unclassified' }
MbndBasicType >> programEntitionInformationData [
	^ self programEntityInformationData
]

{ #category : #'as yet unclassified' }
MbndBasicType >> recordMacroMethodAddition: method withSelector: selector [
	(self isCoreBasicType or: [self isSystemProvidedTypeTemplateInstanceMainChild]) ifTrue: [ 
		self compilationTarget isTheTypeSystemInitialized ifTrue: [
			^ method recordAsExtensionFor: self withSelector: selector
		]
	] ifFalse: [
		method isMacroMessageMethod ifTrue: [ 
			method module == self module ifFalse: [
				method recordAsExtensionFor: self withSelector: selector
			]
		].
	]

]

{ #category : #'as yet unclassified' }
MbndBasicType >> recordOverloadedMethodAddition: method withSelector: selector [
	(self isCoreBasicType or: [self isSystemProvidedTypeTemplateInstanceMainChild]) ifTrue: [ 
		self compilationTarget isTheTypeSystemInitialized ifTrue: [
			^ method recordAsExtensionFor: self withSelector: selector
		]
	] ifFalse: [
		self assert: method module isNotNil.
		method module == self module ifFalse: [
			method recordAsExtensionFor: self withSelector: selector
		]
	].

]

{ #category : #initialization }
MbndBasicType >> setBasicRequiredRTTI [
	<compileTime>
	self addFlag: #requiredBasicRTTI
]

{ #category : #initialization }
MbndBasicType >> setLocalSymbol: symbol valueToGlobalVariable: globalVariable [
	self setLocalSymbol: symbol value: globalVariable.
	(self type isMetaType and: [ self type instanceType == self ]) ifTrue: [ 
		self type setLocalSymbol: symbol value: globalVariable.
	].
]

{ #category : #initialization }
MbndBasicType >> setMethodDictionaryRequired [
	<compileTime>
	self addFlag: #methodDictionaryRequired
]

{ #category : #initialization }
MbndBasicType >> setRequiredRTTI [
	<compileTime>
	self addFlag: #requiredRTTI
]
