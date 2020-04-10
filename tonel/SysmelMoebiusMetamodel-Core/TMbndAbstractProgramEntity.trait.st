Trait {
	#name : #TMbndAbstractProgramEntity,
	#traits : 'TMbndObject + TMbndSymbolBinding',
	#classTraits : 'TMbndObject classTrait + TMbndSymbolBinding classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #visiting }
TMbndAbstractProgramEntity >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #adding }
TMbndAbstractProgramEntity >> addChild: aChild [
	self error: 'Cannot have child program entities here.'
]

{ #category : #adding }
TMbndAbstractProgramEntity >> addLambdaChild: aChild [
	self addPrivateChild: aChild
]

{ #category : #adding }
TMbndAbstractProgramEntity >> addPendingDefinitionFragment: pendingDefinitionFragment [
	pendingDefinitionFragment evaluate
]

{ #category : #adding }
TMbndAbstractProgramEntity >> addPrivateChild: aChild [
	aChild parent: self
]

{ #category : #enumerating }
TMbndAbstractProgramEntity >> allChildrenDo: aBlock [
	self childrenDo: [ :each |
		aBlock value: each.
		each allChildrenDo: aBlock
	]
]

{ #category : #testing }
TMbndAbstractProgramEntity >> canHaveNamespaces [
	^ false
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> children [ 
	^ #()
]

{ #category : #enumerating }
TMbndAbstractProgramEntity >> childrenDo: aBlock [
	self children do: aBlock
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> compilationTarget [
	^ self module compilationTarget
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> definitionPosition [
	^ self parent
		ifNotNil: [ :p | p definitionPosition ]
		ifNil: [ MbndSourcePosition empty ]
]

{ #category : #adding }
TMbndAbstractProgramEntity >> ensurePendingDefinitionBodiesAreEvaluated [
]

{ #category : #adding }
TMbndAbstractProgramEntity >> evaluateAllPendingDefinitionFragments [
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> fillProgramEntityCommonInfoInstance: programEntityInfoInstance [
	self compilationEnvironment hasRuntimeTypeInformation ifFalse: [ ^ self ].
	programEntityInfoInstance
		setField: #name ifExistsWith: [ self name ];
		setField: #children ifExistsWith: [ (self children select: [:child | child hasProgramEntityReflectiveNode ]) asArray]
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> fillProgramEntityInfoInstance: programEntityInfoInstance [
	self fillProgramEntityCommonInfoInstance: programEntityInfoInstance
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> fullName [
	^ self name
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> globalBindingAssociation [
	^ self explicitRequirement
]

{ #category : #testing }
TMbndAbstractProgramEntity >> hasProgramEntityReflectiveNode [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> hasPublicVisibility [
	^ true
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isAbstractSpecificMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isAlwaysExported [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isBlockClosureMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isBlockClosureWithImmediateActivation [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isCompileTimeConstant [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isCompileTimeVariable [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isCompilerGeneratedMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isConcreteMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isFunclet [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isFunctionMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isFunctionReceiverArgumentVariable [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isFunctionSuperReceiverArgumentVariable [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isGlobalVariable [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isMacroMessageMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isMbndProgramEntity [
	^ true
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isModuleSpecializedProgramEntity [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isNamespace [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isNeverExported [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isNonLocalReturnTargetEntity [
	^ true
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isStandaloneModule [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isSystemProvidedTypeTemplate [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isSystemProvidedTypeTemplateInstance [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isTemplate [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isTemplateInstance [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isVariable [
	^ false
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> markCompileTimeEvaluationImpossibility [
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> parent [
	^ nil
]

{ #category : #enumerating }
TMbndAbstractProgramEntity >> postMaterializeSetupParent: newParent withModule: newModule [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> programEntityInformationData [
	^ self programEntityInformationDataClass ifNotNil: [ :programEntityInfoClass |
		| programEntityInfoInstance |
		programEntityInfoInstance := programEntityInfoClass makeInstance.
		self fillProgramEntityInfoInstance: programEntityInfoInstance.
		programEntityInfoInstance
	]
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> programEntityInformationDataClass [
	^ nil
]

{ #category : #'meta builder factories' }
TMbndAbstractProgramEntity >> publicMetaBuilderFactories [
	^ Dictionary new
]

{ #category : #printing }
TMbndAbstractProgramEntity >> qualifiedName [
	<compileTime>
	| parentQualifiedName p |
	p := self parent.
	
	parentQualifiedName := p ifNil: [''] ifNotNil: [ p qualifiedNameForParent ].
	(p isNotNil and: [p isTemplateInstance]) ifTrue: [
		^ parentQualifiedName 
	].

	^ 
	(parentQualifiedName ifEmpty: [ '' ] ifNotEmpty: [ parentQualifiedName , ' ']) , self validName

]

{ #category : #printing }
TMbndAbstractProgramEntity >> qualifiedNameForParent [
	^ self qualifiedName
]

{ #category : #testing }
TMbndAbstractProgramEntity >> requiresDynamicMethodWrappers [
	^ false
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> validName [
	<compileTime>
	^ self name asPrettySymbolName
]

{ #category : #enumerating }
TMbndAbstractProgramEntity >> withAllChildrenDo: aBlock [
	aBlock value: self.
	self allChildrenDo: aBlock.
]
