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
TMbndAbstractProgramEntity >> addPrivateChild: aChild [
	aChild parent: self
]

{ #category : #testing }
TMbndAbstractProgramEntity >> canHaveNamespaces [
	^ false
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> children [ 
	^ #()
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

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> fillProgramEntityCommonInfoInstance: programEntityInfoInstance [
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
TMbndAbstractProgramEntity >> hasPublicVisibility [
	^ true
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isAbstractSpecificMethod [
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
TMbndAbstractProgramEntity >> isMbndProgramEntity [
	^ true
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isNamespace [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isNonLocalReturnTargetEntity [
	^ true
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

{ #category : #testing }
TMbndAbstractProgramEntity >> requiresDynamicMethodWrappers [
	^ false
]
