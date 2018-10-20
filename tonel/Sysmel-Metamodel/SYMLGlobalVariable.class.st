Class {
	#name : #SYMLGlobalVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'referenceType',
		'ssaValue',
		'currentValue'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> assignValue: initialValue [
	<compileTime>
	<lazy>
	
	| initialValueNode initialValueType |
	initialValueNode := initialValue node semanticAnalysisInEnvironment: initialValue environment.
	initialValueType := initialValueNode evaluateTypeInEnvironment: initialValue environment.
	type ifNil: [
		self type: initialValueType valueType.
	].
	
	currentValue := (initialValue coercedIntoType: type at: initialValue position) unwrapSysmelValue
]

{ #category : #'as yet unclassified' }
SYMLGlobalVariable >> doCreateSSADebugInformation [
	^ (SLVMDebugVariable scope: nil name: self validName)
		type: self type ssaType;
		yourself
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> ensureSSAValue [
	ssaValue ifNotNil: [ ^ ssaValue ].
	
	ssaValue := SLVMGlobalVariable module: module ssaModule
		name: self mangledName
		valueType: type ssaType
		storage: SLVMType genericStorage.
	ssaValue minimalAlignment: alignment.
	ssaValue unmangledName: self fullUnmangledName.
	self setSSAGlobalDebuggingInformation: ssaValue.	

	self isExternal ifTrue: [
		ssaValue makeExternal
	] ifFalse: [ 
		ssaValue initialValue: (type generateSSAConstant: currentValue forModule: self module).
	].

	type hasNonTrivialInitialization ifTrue: [ 
		module createSSAGlobal: ssaValue at: definitionPosition constructorWith: [ :builder |
			self generateSSAVariable: ssaValue constructionWith: builder
		]
	].
	type hasNonTrivialFinalization ifTrue: [ 
		module createSSAGlobal: ssaValue at: definitionPosition destructorWith: [ :builder |
			self generateSSAVariable: ssaValue destructionWith: builder
		].
	].

	^ ssaValue
]

{ #category : #testing }
SYMLGlobalVariable >> evaluateBoundIdentifierToMe: identifier inEnvironment: anEnvironment [
	self isReadOnly ifTrue: [
		^ currentValue sysmelValueWithType: referenceType inEnvironment: anEnvironment
	].
	^ self sysmelValueWithType: referenceType inEnvironment: anEnvironment
]

{ #category : #testing }
SYMLGlobalVariable >> externC [
	<compileTime>
	self addFlag: #'extern-c'
]

{ #category : #testing }
SYMLGlobalVariable >> external [
	<compileTime>
	self addFlag: #external
]

{ #category : #'code generation' }
SYMLGlobalVariable >> generateSSACode [
	self validSSAValue
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> generateSSAReferenceWith: builder [
	^ self validSSAValue
]

{ #category : #testing }
SYMLGlobalVariable >> isExternC [
	<compileTime>
	^ self hasFlag: #'extern-c'
]

{ #category : #testing }
SYMLGlobalVariable >> isExternal [
	<compileTime>
	^ self hasFlag: #external
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> mangledName [
	self isExternC ifTrue: [ ^ name ].
	^ super mangledName
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> name: aNewName [
	<compileTime>
	parent ifNotNil: [
		self tryToAddToParentWithName: aNewName
	].
	name := aNewName.

]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> referenceType [
	^ referenceType
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> type: aType [
	<compileTime>
	super type: aType.
	referenceType := self isReadOnly
		ifTrue: [ aType const ref ]
		ifFalse: [ aType ref ].
	
]

{ #category : #'semantic analysis' }
SYMLGlobalVariable >> validSSAValue [
	ssaValue ifNil: [ self ensureSSAValue ].
	^ ssaValue
]
