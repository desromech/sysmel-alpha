Trait {
	#name : #TMbndProgramEntity,
	#instVars : [
		'publicMetaBuilderFactories',
		'globalBindingAssociation'
	],
	#traits : 'TMbndAbstractProgramEntity + TMbndAbstractMacroMethodContainer + TMbndAbstractMethodContainer + TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndAbstractProgramEntity classTrait + TMbndAbstractMacroMethodContainer classTrait + TMbndAbstractMethodContainer classTrait + TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
TMbndProgramEntity >> createPublicAccessorsIn: aParent [
	self assert: self name isMbndAnonymousSymbol not.
	aParent addStaticAccessor: (MbndPublicProgramEntityAccessor new programEntity: self) for: self name asSymbol
]

{ #category : #accessing }
TMbndProgramEntity >> createPublicMetaBuilderFactories [
	^ Dictionary newFromPairs: self getPublicMetaBuilderFactoryList
]

{ #category : #serialization }
TMbndProgramEntity >> encodeFieldsForMessagePackWith: graphEncoder [
	^ self explicitRequirement
]

{ #category : #serialization }
TMbndProgramEntity >> encodeGraphForMessagePack [
	^ self encodeGraphForMessagePackWith: SLVMSerializationGraphEncoder new.
]

{ #category : #serialization }
TMbndProgramEntity >> encodeGraphForMessagePackWith: graphEncoder [
	(graphEncoder encodeExternalProgramEntityReferenceFor: self) ifNotNil: [ :ref | ^ ref ].

	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [self encodeFieldsForMessagePackWith: graphEncoder]
]

{ #category : #'semantic analysis' }
TMbndProgramEntity >> enqueueDelayedSemanticAnalysis [
	self module enqueueProgramEntityWithDelayedSemanticAnalysis: self
]

{ #category : #'semantic analysis' }
TMbndProgramEntity >> ensureSemanticAnalysis [
]

{ #category : #'as yet unclassified' }
TMbndProgramEntity >> generateTargetCodeModuleOnlyForMyself [
	^ self module generateTargetCodeModuleForProgramEntities: { self }
]

{ #category : #accessing }
TMbndProgramEntity >> getExtraMetaBuilderFactoryList [
	^ #()
]

{ #category : #accessing }
TMbndProgramEntity >> getPublicMetaBuilderFactoryList [
	^ { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]

{ #category : #accessing }
TMbndProgramEntity >> globalBindingAssociation [
	^ globalBindingAssociation ifNil: [ globalBindingAssociation := GlobalVariable key: self name value: self ]
]

{ #category : #testing }
TMbndProgramEntity >> isMessageMethod [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isVTablePointerField [
	^ false
]

{ #category : #serialization }
TMbndProgramEntity >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	^ self explicitRequirement
]

{ #category : #accessing }
TMbndProgramEntity >> module [
	self explicitRequirement
]

{ #category : #accessing }
TMbndProgramEntity >> name [
	^ self explicitRequirement
]

{ #category : #scope }
TMbndProgramEntity >> programEntityScope [
	^ self programEntityScopeClass new programEntity: self
]

{ #category : #scope }
TMbndProgramEntity >> programEntityScopeClass [
	^ MbndProgramEntityScope
]

{ #category : #accessing }
TMbndProgramEntity >> publicMetaBuilderFactories [
	^ publicMetaBuilderFactories ifNil: [ publicMetaBuilderFactories := self createPublicMetaBuilderFactories ]
]
