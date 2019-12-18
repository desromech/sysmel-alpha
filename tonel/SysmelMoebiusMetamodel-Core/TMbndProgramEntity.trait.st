Trait {
	#name : #TMbndProgramEntity,
	#instVars : [
		'publicMetaBuilderFactories'
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
		#message . MbndMessageMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]

{ #category : #testing }
TMbndProgramEntity >> isCompilerGeneratedMethod [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isConcreteMethod [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isFunclet [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isFunctionMethod [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isGlobalVariable [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isMessageMethod [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isVTablePointerField [
	^ false
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
