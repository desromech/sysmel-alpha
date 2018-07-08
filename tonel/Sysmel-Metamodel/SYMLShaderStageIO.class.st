Class {
	#name : #SYMLShaderStageIO,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'allowedInStages',
		'analyzed',
		'stageVariables',
		'inputStageVariables',
		'outputStageVariables',
		'shaderInterfaceGenerated',
		'inputInterfaceType',
		'outputInterfaceType',
		'spvInputVariable',
		'spvOutputVariable'
	],
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #adding }
SYMLShaderStageIO >> addAllowedStage: stageName [
	allowedInStages := allowedInStages copyWith: stageName
]

{ #category : #adding }
SYMLShaderStageIO >> addShaderStageVariable: variable at: aPosition [
	symbols at: variable name ifPresent: [ :existent |
		self error: 'Trying to override shader stage io variable {1}.' format: { existent name printString } at: aPosition
	] ifAbsentPut: [ variable ].

	variable isInput ifTrue: [
		variable slotIndex: inputStageVariables size.
		inputStageVariables add: variable.
	] ifFalse: [ 
		self assert: variable isOutput.
		variable slotIndex: outputStageVariables size.
		outputStageVariables add: variable.
	].
]

{ #category : #stage }
SYMLShaderStageIO >> compute [
	<compileTime>
	self addAllowedStage: #compute
]

{ #category : #'shader interface' }
SYMLShaderStageIO >> createInterfaceSSAVariableSuffix: suffix type: interfaceType storage: interfaceStorage [
	| result |
	interfaceType ifNil: [ ^ nil ].
	
	result := SLVMGlobalVariable module: self module ssaModule
		name: (self mangledName , suffix) asSymbol
		valueType: interfaceType
		storage: interfaceStorage.
	result propertyAt: #shaderInterface put: true.
	^ result
]

{ #category : #definition }
SYMLShaderStageIO >> definitionScopeClass [
	^ SYMLShaderStageIOScope
]

{ #category : #'shader interface' }
SYMLShaderStageIO >> ensureShaderInterfaceIsGenerated [
	self compilationTarget isSpirV ifFalse: [ self error: 'Shader stage variable access is not yet implemented here.' ].
	inputStageVariables do: #generateSpirVVariable.
	outputStageVariables do: #generateSpirVVariable.
	
	
]

{ #category : #stage }
SYMLShaderStageIO >> fragment [
	<compileTime>
	self addAllowedStage: #fragment
]

{ #category : #'shader interface' }
SYMLShaderStageIO >> generateInterfaceSSAType: interfaceVariables suffix: suffix kind: kind [
	interfaceVariables ifEmpty: [ ^ nil ].
	
	^ (SLVMStructureType name: (self mangledName , suffix) asSymbol
		types: (interfaceVariables collect: [:var | var type ssaType])
		kind: kind
		names: (interfaceVariables collect: #name))
		memberAnnotations: (interfaceVariables collect: #shaderInterfaceAnnotations);
		yourself
]

{ #category : #'code generation' }
SYMLShaderStageIO >> generateSSACode [
	super generateSSACode.
	children do: #generateSSACode
]

{ #category : #stage }
SYMLShaderStageIO >> geometry [
	<compileTime>
	self addAllowedStage: #geometry
]

{ #category : #initialization }
SYMLShaderStageIO >> initialize [
	super initialize.
	allowedInStages := #().
	analyzed := false.
	inputStageVariables := OrderedCollection new.
	outputStageVariables := OrderedCollection new.
	shaderInterfaceGenerated := false.
]

{ #category : #testing }
SYMLShaderStageIO >> isShaderStageIO [
	^ true
]

{ #category : #accessing }
SYMLShaderStageIO >> mangledName [
	| escapedName |
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
			escapedName := self validName sysmelEscapeForMangling.
			out
				nextPutAll: self parentMangledName;
				nextPutAll: '_sio';
				print: escapedName size;
				nextPutAll: escapedName.
		]
	]
]

{ #category : #'semantic analysis' }
SYMLShaderStageIO >> semanticAnalysis [
	super semanticAnalysis.
	analyzed ifTrue: [ ^ self ].
	analyzed := true.
	
	children do: #semanticAnalysis
]

{ #category : #'as yet unclassified' }
SYMLShaderStageIO >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	| identifier |
	symbols at: message selector ifPresent: [ :value |
		identifier := SYMLAPSGIdentifier new
			position: message;
			value: message selector;
			yourself.
		^ value analyzeAPSGIdentifierToMe: identifier inEnvironment: environment
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLShaderStageIO >> spvInputVariable [
	^ spvInputVariable
]

{ #category : #accessing }
SYMLShaderStageIO >> spvOutputVariable [
	^ spvOutputVariable
]

{ #category : #stage }
SYMLShaderStageIO >> vertex [
	<compileTime>
	self addAllowedStage: #vertex
]
