Class {
	#name : #SYMLAbstractFunction,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'returnType',
		'body',
		'bodyEnvironment',
		'analyzedBody',
		'arguments',
		'functionType',
		'callingConvention',
		'receiverType',
		'receiver'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> CVariadic [
	<compileTime>
	self addFlag: #cvariadic
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> addedToAbstractType: anAbstractType [
	receiverType := anAbstractType.
	receiver := SYMLFunctionReceiver new name: #self; type: receiverType; yourself
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> analyzeAndEvaluateMessage: message toReceiver: aReceiver inEnvironment: environment at: aPosition [
	| activationScope result hasResult |
	self analyzedBody.
	
	activationScope := SYMLFunctionActivationScope parent: bodyEnvironment.
	activationScope function: self.
	
	receiver ifNotNil: [ 
		activationScope addSymbol: receiver name value: (aReceiver asSysmelValueInEnvironment: environment)
	].

	"TODO: Set the arguments"
	
	result := nil.
	hasResult := false.
	[ 
		analyzedBody evaluateInEnvironment: activationScope
	] on: SYMLValueReturnException do: [ :exception |
		hasResult := true.
		result := exception value
	].

	(hasResult not and: [ returnType ~~ self compilationTarget voidType ]) ifTrue: [ 
		self error: 'Compile time called function {1} did not return a required value.' format: {self validName printString} at: aPosition
	].

	^ result
]

{ #category : #accessing }
SYMLAbstractFunction >> analyzedBody [
	| analysisScope |
	analyzedBody ifNotNil: [ ^ analyzedBody ].
	body ifNil: [ self error: 'Cannot call function without a body.' ].
	analysisScope := self createAnalysisScope.
	analyzedBody := body semanticAnalysisInEnvironment: analysisScope.
	^ analyzedBody
]

{ #category : #accessing }
SYMLAbstractFunction >> createAnalysisScope [
	| analysisScope |
	analysisScope := (SYMLFunctionAnalysisScope parent: bodyEnvironment) function: self.
	receiver ifNotNil: [ 
		analysisScope addSymbol: receiver name value: receiver
	].
	arguments do: [ :arg |
		analysisScope addSymbol: arg name value: arg
	].

	^ analysisScope
]

{ #category : #initialization }
SYMLAbstractFunction >> initialize [
	super initialize.
	callingConvention := #cdecl.
	
]

{ #category : #testing }
SYMLAbstractFunction >> isAbstractFunction [
	^ true
]

{ #category : #testing }
SYMLAbstractFunction >> isCVariadic [
	<compileTime>
	^ self hasFlag: #'cvariadic'
]

{ #category : #testing }
SYMLAbstractFunction >> isMethod [
	^ false
]

{ #category : #accessing }
SYMLAbstractFunction >> receiverType [
	<compileTime>
	^ receiverType ifNil: [ self compilationTarget voidType ]
]

{ #category : #accessing }
SYMLAbstractFunction >> returnType [
	<compileTime>
	^ returnType
]
