Class {
	#name : #SYMLAPSGLocalInitialization,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'local',
		'initialization',
		'coercionRule'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGLocalInitialization >> coercionRule [
	^ coercionRule
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> coercionRule: anObject [
	coercionRule := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> evaluateInEnvironment: anEnvironment [
	| initialValue convertedValue |
	local isReadOnly ifTrue: [
		initialValue := initialization evaluateInEnvironment: anEnvironment.
		convertedValue := initialValue coercedIntoType: local type at: self.
		local definitionEnvironment == anEnvironment ifTrue: [
			local currentValue: convertedValue value
		] ifFalse: [ 
			anEnvironment addSymbol: local name value: convertedValue.
		].

		^ convertedValue
	].

	local definitionEnvironment == anEnvironment ifFalse: [ 
		local createDefinititionInActivationEnvironment: anEnvironment
	].

	^ initialization evaluateInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> evaluateTypeInEnvironment: anEnvironment [
	^ local referenceType
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> generateSSACodeWith: builder [
	| localReference initialValue convertedInitialValue |
	builder withDebugPosition: self position do: [
		local isReadOnly ifTrue: [ 
			self assert: initialization isNotNil.
			initialValue := initialization generateSSACodeWith: builder.
			convertedInitialValue := coercionRule convertSSAValue: initialValue to: local type with: builder at: self.
			local ssaValue: convertedInitialValue.
			builder compilationTarget emittingDebugInformation ifTrue: [ 
				builder debugSetVariable: local createSSADebugInformation value: convertedInitialValue
			].

			^ convertedInitialValue
		].
	
		local type hasNonTrivialInitialization ifTrue: [ 
			local generateSSAVariable: local ssaValue constructionWith: builder
		].

		local type hasNonTrivialFinalization ifTrue: [
			self halt
			"local generateSSAVariable: local ssaValue constructionWith: builder"
		].
	
		initialization ifNotNil: [
			initialization generateSSACodeWith: builder
		].

		localReference := local generateSSAReferenceWith: builder.
		builder compilationTarget emittingDebugInformation ifTrue: [ 
			(builder debugDeclareVariable: localReference)
				debugInformation: local createSSADebugInformation
		].
		
		^ localReference
	]
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> initialization [
	^ initialization
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> initialization: anObject [
	initialization := anObject
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> local [
	^ local
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> local: anObject [
	local := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> macroExpansionInEnvironment: anEnvironment [
	^ self shallowCopy
		initialization: (initialization ifNotNil: [initialization macroExpansionInEnvironment: anEnvironment]);
		yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> semanticAnalysisInEnvironment: anEnvironment [
	local isReadOnly ifTrue: [ 
		initialization ifNil: [
			self error: 'Immutable local "{1}" requires an initial value.' format: { local name } at: self
		].
	].

	self assert: initialization isNotNil.
	^ self
]
