Class {
	#name : #SYMLAPSGBlockClosureInlineActivation,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'blockClosure',
		'arguments',
		'coercionRules'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> blockClosure [
	^ blockClosure
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> blockClosure: anObject [
	blockClosure := anObject
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> coercionRules [
	^ coercionRules
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> coercionRules: anObject [
	coercionRules := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGBlockClosureInlineActivation >> generateSSACodeWith: builder [
	"Cast the arguments"
	| coercedArguments expectedArguments targetType coercionRule |
	expectedArguments := blockClosure arguments.
	coercedArguments := arguments collectWithIndex: [ :arg :index |
		targetType := (expectedArguments at: index) type.
		coercionRule := coercionRules at: index.
		coercionRule convertSSAValue: (arg generateSSACodeWith: builder) to: targetType with: builder at: arg
	].

	^ blockClosure generateSSAInlineCall: coercedArguments with: builder
]

{ #category : #'meta evaluation' }
SYMLAPSGBlockClosureInlineActivation >> semanticAnalysisInEnvironment: environment [
	| closureArguments analyzedArguments expectedArgumentType argumentType analyzedCoercionRules |
	coercionRules ifNotNil: [ ^ self ].
	
	closureArguments := blockClosure arguments.
	arguments size = closureArguments size ifFalse: [
		self error: 'Mismatching number of argument for local closure activation.' at: position.
	].

	analyzedArguments := arguments collect: [ :arg | arg semanticAnalysisInEnvironment: environment ].
	analyzedCoercionRules := arguments collectWithIndex: [ :arg :index |
		expectedArgumentType := (closureArguments at: index) type.
		argumentType := arg evaluateTypeInEnvironment: environment.
		argumentType node: arg coercedImplicitlyInto: expectedArgumentType at: position
	].
	
	blockClosure blockClosure isInlined: true.
	environment definitionProgramEntity addInlinedBlockClosure: blockClosure blockClosure.
	^ self shallowCopy
		arguments: analyzedArguments;
		coercionRules: analyzedCoercionRules;
		yourself
]
