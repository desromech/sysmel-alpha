Class {
	#name : #SYMLFunctionType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'compilationTarget',
		'arguments',
		'returnType',
		'callingConvention',
		'variadic',
		'argumentsMangledName',
		'functionAnalysisType'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #comparing }
SYMLFunctionType >> = other [
	^ self class == other class and:
	[ arguments = other arguments and:
	[ returnType = other returnType and:
	[ variadic = other variadic and:
	[ callingConvention == other callingConvention ]]]]
]

{ #category : #accessing }
SYMLFunctionType >> arguments [
	<compileTime>
	^ arguments
]

{ #category : #accessing }
SYMLFunctionType >> arguments: anObject [
	<compileTime>
	arguments := anObject
]

{ #category : #accessing }
SYMLFunctionType >> argumentsMangledName [
	^ argumentsMangledName ifNil: [ argumentsMangledName := ByteString streamContents: [ :out |
			arguments do: [ :arg |
				out nextPutAll: arg sysmelMangledValue
			]
		]
	]
]

{ #category : #accessing }
SYMLFunctionType >> asConcreteTypeForFunctionAnalysis [
	^ functionAnalysisType ifNil: [ functionAnalysisType := compilationTarget functionArguments: (arguments collect: #asConcreteTypeForFunctionAnalysis) returnType: returnType asConcreteTypeForFunctionAnalysis callingConvention: callingConvention variadic: variadic]
]

{ #category : #'code generation' }
SYMLFunctionType >> buildSSAType [
	| argumentSSAType returnSSAType |
	functionAnalysisType ~~ self ifTrue: [ 
		^ self asConcreteTypeForFunctionAnalysis buildSSAType.
	].

	argumentSSAType := arguments collect: #ssaType.
	returnSSAType := returnType ssaType.
	^ (SLVMFunctionType callingConvention: callingConvention arguments: argumentSSAType returnType: returnSSAType)
		variadic: variadic;
		yourself
]

{ #category : #accessing }
SYMLFunctionType >> callingConvention [
	<compileTime>
	^ callingConvention
]

{ #category : #accessing }
SYMLFunctionType >> callingConvention: anObject [
	<compileTime>
	callingConvention := anObject
]

{ #category : #accessing }
SYMLFunctionType >> compilationTarget [
	<compileTime>
	^ compilationTarget
]

{ #category : #accessing }
SYMLFunctionType >> compilationTarget: anObject [
	<compileTime>
	compilationTarget := anObject.
	definitionEnvironment := compilationTarget fakeEnvironment.
	self addTypeKindBaseTrait
]

{ #category : #testing }
SYMLFunctionType >> hasDynamicMessageFunctionArguments [
	arguments do: [ :arg | arg isAnyDynamicObjectType ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #comparing }
SYMLFunctionType >> hash [
	^ self class identityHash bitXor:
	( arguments hash bitXor:
	( returnType hash bitXor:
	( variadic hash bitXor:
	( callingConvention identityHash))))
]

{ #category : #'as yet unclassified' }
SYMLFunctionType >> isAnonymousType [
	^ true
]

{ #category : #testing }
SYMLFunctionType >> isDynamicMessageFunctionType [
	returnType isAnyDynamicObjectType ifFalse: [ ^ false ].
	^ self hasDynamicMessageFunctionArguments
]

{ #category : #testing }
SYMLFunctionType >> isFunctionType [
	^ true
]

{ #category : #testing }
SYMLFunctionType >> isMatchedByOverridingMethod: derivedFunctionType [
	"Check the argument count."
	(arguments size = derivedFunctionType arguments size) ifFalse: [ ^ false ].

	"Check the return type."
	(returnType isSysmelReinterpretKindOf: derivedFunctionType returnType) ifFalse: [ ^ false ].
	
	"Check the argument types."
	arguments doWithIndex: [ :arg :index |
		((derivedFunctionType arguments at: index) isSysmelReinterpretKindOf: arg) ifFalse: [ ^ false ].
	].

	^ true
]

{ #category : #printing }
SYMLFunctionType >> printOn: aStream [
	aStream nextPut: $(.
	arguments doWithIndex: [ :arg :index |
		index > 1 ifTrue: [ aStream nextPutAll: ', ' ].
		aStream print: arg. 
	].

	aStream nextPutAll: ') -> '.
	aStream print: returnType.
]

{ #category : #accessing }
SYMLFunctionType >> returnType [
	<compileTime>
	^ returnType
]

{ #category : #accessing }
SYMLFunctionType >> returnType: anObject [
	<compileTime>
	returnType := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionType >> typeKindBaseTrait [
	^ self compilationTarget functionTypeTrait
]

{ #category : #printing }
SYMLFunctionType >> validName [
	^ name ifNil: [
		name := ByteString streamContents: [ :out |
			out nextPutAll: '(('.
			arguments doWithIndex: [ :arg :index |
				index > 1 ifTrue: [ out nextPutAll: ', ' ].
				out print: arg. 
			].

			out nextPutAll: ') -> '.
			out print: returnType.
			out nextPut: $).
		]
	]
]

{ #category : #accessing }
SYMLFunctionType >> variadic [
	<compileTime>
	^ variadic
]

{ #category : #accessing }
SYMLFunctionType >> variadic: anObject [
	<compileTime>
	variadic := anObject
]

{ #category : #writing }
SYMLFunctionType >> writeTypedSelectorDataInto: out omitReceiver: omitReceiver [
	| argumentsWithoutReceiver |
	argumentsWithoutReceiver := omitReceiver ifTrue: [ arguments allButFirst ] ifFalse: [ arguments ].
	argumentsWithoutReceiver ifNotEmpty: [ 
		out nextPut: $(.
		argumentsWithoutReceiver doWithIndex: [ :arg :index |
			index > 1 ifTrue: [
				out nextPut: $,
			].
			arg writeTypedSelectorDataInto: out omitReceiver: false
		].
		out nextPut: $).
	].

	out
		nextPutAll: '->'.
	returnType writeTypedSelectorDataInto: out omitReceiver: false
]
