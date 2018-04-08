Class {
	#name : #SYMLProgramEntity,
	#superclass : #SYMLObject,
	#instVars : [
		'parent',
		'flags'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #flags }
SYMLProgramEntity >> addFlag: aFlag [
	<compileTime>
	flags := (flags copyWithout: aFlag) copyWith: aFlag
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
	parent := anObject
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
	method ifNotNil: [ self halt ].
	^ super sendCompileTimeMessage: message inEnvironment: environment at: aPosition
]
