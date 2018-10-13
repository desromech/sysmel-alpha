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
SYMLAPSGLocalInitialization >> generateSSACodeWith: aBuilder [
	| localReference initialValue convertedInitialValue |
	aBuilder withDebugPosition: self position do: [
		local isReadOnly ifTrue: [ 
			self assert: initialization isNotNil.
			initialValue := initialization generateSSACodeWith: aBuilder.
			convertedInitialValue := coercionRule convertSSAValue: initialValue to: local type with: aBuilder at: self.
			local ssaValue: convertedInitialValue.
			aBuilder compilationTarget emittingDebugInformation ifTrue: [ 
				aBuilder debugSetVariable: local createSSADebugInformation value: convertedInitialValue
			].

			^ convertedInitialValue
		].
	
		initialization ifNotNil: [
			initialization generateSSACodeWith: aBuilder
		].

		localReference := local generateSSAReferenceWith: aBuilder.
		aBuilder compilationTarget emittingDebugInformation ifTrue: [ 
			(aBuilder debugDeclareVariable: localReference)
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
