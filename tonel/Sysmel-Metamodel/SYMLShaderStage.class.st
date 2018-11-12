Class {
	#name : #SYMLShaderStage,
	#superclass : #SYMLAbstractFunction,
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #definition }
SYMLShaderStage >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	^ self definition: bodyLazyValue asFunctionalValue
]

{ #category : #associating }
SYMLShaderStage >> buildFunctionType [
	returnType ifNil: [ returnType := self compilationTarget voidType ].
	functionType := self compilationTarget
		functionArguments: #() returnType: returnType
		callingConvention: callingConvention variadic: self isCVariadic.

]

{ #category : #'code generation' }
SYMLShaderStage >> decorateSSAValue: functionSSAValue [
	functionSSAValue propertyAt: self shaderStageEntryPointDecoration put: true
]

{ #category : #accessing }
SYMLShaderStage >> definition: bodyLazyValue [
	<compileTime>
	<lazy>
	
	body := bodyLazyValue asAPSGNodeValueWithError: ('Expected an APSG node for the definition of the function {1}.' format: { self validName }) at: bodyLazyValue node.
	bodyEnvironment := bodyLazyValue environment.
	returnType := self compilationTarget voidType.
]

{ #category : #initialization }
SYMLShaderStage >> initialize [
	super initialize.
	arguments := #().
	
]

{ #category : #accessing }
SYMLShaderStage >> isExternC [
	^ false
]

{ #category : #'as yet unclassified' }
SYMLShaderStage >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(name isNil and: [message selector numArgs = 0]) ifTrue: [
		self name: message selector.
		^ message receiver
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLShaderStage >> shaderStageEntryPointDecoration [
	self subclassResponsibility
]
