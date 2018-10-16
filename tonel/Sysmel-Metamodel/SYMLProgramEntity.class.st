Class {
	#name : #SYMLProgramEntity,
	#superclass : #SYMLObjectWithType,
	#instVars : [
		'parent',
		'flags',
		'anonNameAllocation'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #flags }
SYMLProgramEntity >> addFlag: aFlag [
	<compileTime>
	flags := (flags copyWithout: aFlag) copyWith: aFlag
]

{ #category : #adding }
SYMLProgramEntity >> addLocal: aLocalVariable [
	aLocalVariable isAnonymousGlobal: true
]

{ #category : #methods }
SYMLProgramEntity >> addMacroFunctionPattern: macroFunctionPattern withSelector: selector [
	| group |
	^ self symbol: selector ifPresent: [ :existentGroup |
		existentGroup isFunctionalPatternGroup ifFalse: [ 
			self error: 'Cannot add macro/function pattern into non-macro group {1}.' format: { selector printString } at: macroFunctionPattern definitionPosition.
		].
	
		macroFunctionPattern addToPatternGroup: existentGroup.
	] ifAbsentPut: [
		group := SYMLMacroFunctionPatternGroup new
			name: macroFunctionPattern name;
			parent: self;
			module: self module;
			definitionNode: macroFunctionPattern definitionNode;
			definitionEnvironment: macroFunctionPattern definitionEnvironment;
			yourself.
		macroFunctionPattern addToPatternGroup: group.
		self ensureSemanticAnalysis.
		group
	]
]

{ #category : #methods }
SYMLProgramEntity >> addMacroMethodPattern: macroMethodPattern withSelector: selector [
	| group |
	^ self methodWithSelector: selector ifPresent: [ :existentGroup |
		existentGroup isFunctionalPatternGroup ifFalse: [ 
			self error: 'Cannot add macro pattern into non-macro group {1}.' format: { selector printString } at: macroMethodPattern definitionPosition.
		].
	
		macroMethodPattern addToPatternGroup: existentGroup
	] ifAbsentPut: [
		group := SYMLMacroMethodPatternGroup new
			parent: self;
			module: self module;
			name: selector;
			definitionNode: macroMethodPattern definitionNode;
			definitionEnvironment: macroMethodPattern definitionEnvironment;
			yourself.
		macroMethodPattern addToPatternGroup: group.
		self ensureSemanticAnalysis.
		group
	]
]

{ #category : #methods }
SYMLProgramEntity >> addMethod: value withSelector: selector [
	self methodWithSelector: selector ifPresent: [ :existent |
		self error: 'Trying to override method {1} with value {2}.' format: { selector printString . value }
	] ifAbsentPut: [ value ]
]

{ #category : #adding }
SYMLProgramEntity >> addSymbol: aSymbolName value: aValue [
	aSymbolName = '_' ifTrue: [ ^ self ].
	
	^ self symbol: aSymbolName ifPresent: [ :existent |
		self error: 'Trying to override symbol {1} with {2}.' format: { aSymbolName printString . aValue printString }
	] ifAbsentPut: [ self ensureSemanticAnalysis . aValue ]
]

{ #category : #accessing }
SYMLProgramEntity >> addedChild: aChild [
]

{ #category : #'as yet unclassified' }
SYMLProgramEntity >> allocateAnonName [
	| result |
	result := ('__anon' , anonNameAllocation asString) asSymbol.
	anonNameAllocation := anonNameAllocation + 1.
	^ result
	
]

{ #category : #accessing }
SYMLProgramEntity >> ensureSemanticAnalysis [
]

{ #category : #'as yet unclassified' }
SYMLProgramEntity >> evaluateBoundIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ anEnvironment lookSymbolRecursively: identifier value ifAbsent: [
		self error: 'Failed to find identifier {1}.' format: { identifier value } at: identifier position
	].
]

{ #category : #accessing }
SYMLProgramEntity >> evaluateReferenceAt: position [
	^ self sysmelValueWithType: self module compilationTarget compilerObjectType inEnvironment: nil
]

{ #category : #accessing }
SYMLProgramEntity >> fullUnmangledName [
	self subclassResponsibility

]

{ #category : #'code generation' }
SYMLProgramEntity >> generateSSACode [
]

{ #category : #'code generation' }
SYMLProgramEntity >> generateSSAReferenceWith: builder [
	self error: 'Cannot generate program entity ssa reference.'
]

{ #category : #flags }
SYMLProgramEntity >> hasFlag: aFlag [
	<compileTime>
	^ flags includes: aFlag
]

{ #category : #initialization }
SYMLProgramEntity >> initialize [
	super initialize.
	flags := #().
	anonNameAllocation := 0.
	
]

{ #category : #testing }
SYMLProgramEntity >> isMetaObject [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLProgramEntity >> lookMetaMethodSelector: selector [
	^ nil
]

{ #category : #'symbol lookup' }
SYMLProgramEntity >> lookSymbol: symbol [
	^ self lookSymbol: symbol ifPresent: [ :value | value ]
]

{ #category : #accessing }
SYMLProgramEntity >> lookSymbol: symbol ifPresent: ifPresentBlock [
	^ nil
]

{ #category : #'accessing method dictionary' }
SYMLProgramEntity >> lookupCompileTimeSelector: selector [
	^ nil
]

{ #category : #'accessing method dictionary' }
SYMLProgramEntity >> lookupSelector: selector [
	^ nil
]

{ #category : #accessing }
SYMLProgramEntity >> mangledName [
	self subclassResponsibility

]

{ #category : #methods }
SYMLProgramEntity >> methodWithSelector: selector ifPresent: presentBlock ifAbsentPut: absentBlock [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLProgramEntity >> parent [
	^ parent
]

{ #category : #accessing }
SYMLProgramEntity >> parent: anObject [
	parent := anObject.
	parent ifNotNil: [ parent addedChild: self ]
]

{ #category : #accessing }
SYMLProgramEntity >> parentFullUnmangledName [
	^ parent ifNil: [ '' ] ifNotNil: [ parent parentFullUnmangledName ]
]

{ #category : #accessing }
SYMLProgramEntity >> parentMangledName [
	^ parent ifNil: [ '_S' ] ifNotNil: [ parent mangledName ]
]

{ #category : #flags }
SYMLProgramEntity >> removeFlag: aFlag [
	<compileTime>
	flags := flags copyWithout: aFlag
]

{ #category : #'semantic analysis' }
SYMLProgramEntity >> semanticAnalysis [
	
]

{ #category : #'accessing method dictionary' }
SYMLProgramEntity >> sendCompileTimeMessage: message inEnvironment: environment at: aPosition [
	| method |
	method := self lookupCompileTimeSelector: message selector.
	method ifNotNil: [
		^ method semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].
	^ super sendCompileTimeMessage: message inEnvironment: environment at: aPosition
]

{ #category : #adding }
SYMLProgramEntity >> symbol: aSymbol ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	self subclassResponsibility
]

{ #category : #enumerating }
SYMLProgramEntity >> usedAndExportedNamespacesDo: aBlock [
]
