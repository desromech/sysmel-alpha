Class {
	#name : #SYMLProgramEntity,
	#superclass : #SYMLObject,
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

{ #category : #methods }
SYMLProgramEntity >> addMacroMethodPattern: macroMethodPattern withSelector: selector [
	| group |
	^ self methodWithSelector: selector ifPresent: [ :existentGroup |
		existentGroup isMacroPatternGroup ifFalse: [ 
			self error: 'Cannot add macro pattern into non-macro group {1}.' format: { selector printString } at: macroMethodPattern definitionPosition.
		].
	
		macroMethodPattern addToPatternGroup: existentGroup
	] ifAbsentPut: [
		group := SYMLMacroMethodPatternGroup new
			parent: parent;
			module: self module;
			definitionNode: macroMethodPattern definitionNode;
			definitionEnvironment: macroMethodPattern definitionEnvironment;
			yourself.
		macroMethodPattern addToPatternGroup: group.
		group
	]
]

{ #category : #methods }
SYMLProgramEntity >> addMethod: value withSelector: selector [
	self methodWithSelector: selector ifPresent: [ :existent |
		self error: 'Trying to override method {1} with value {2}.' format: { selector printString . value }
	] ifAbsentPut: [ value ]
]

{ #category : #accessing }
SYMLProgramEntity >> addedChild: aChild [
]

{ #category : #'as yet unclassified' }
SYMLProgramEntity >> addedToAbstractType: anAbstractType [
]

{ #category : #'as yet unclassified' }
SYMLProgramEntity >> allocateAnonName [
	| result |
	result := ('__anon' , anonNameAllocation asString) asSymbol.
	anonNameAllocation := anonNameAllocation + 1.
	^ result
	
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
	method := self lookupSelector: message selector.
	method ifNotNil: [
		^ method semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].
	^ super sendCompileTimeMessage: message inEnvironment: environment at: aPosition
]
