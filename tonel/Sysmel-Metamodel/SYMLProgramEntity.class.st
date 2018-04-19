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

{ #category : #'accessing method dictionary' }
SYMLProgramEntity >> lookupSelector: selector [
	^ nil
]

{ #category : #accessing }
SYMLProgramEntity >> mangledName [
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
