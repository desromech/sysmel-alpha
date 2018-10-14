Class {
	#name : #SYMLSendMessageMacro,
	#superclass : #SYMLMacro,
	#instVars : [
		'messageMethod'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLSendMessageMacro >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver arguments |
	receiver := (message receiver evaluateInEnvironment: anEnvironment).
	arguments := message arguments collect: [ :arg | (arg evaluateInEnvironment: anEnvironment)].
	^ receiver value sysmelPerform: message selector withArguments: arguments
]

{ #category : #'macro compilation' }
SYMLSendMessageMacro >> generateMessage: messageNode ssaCodeWith: builder [
	| receiverValue arguments expectedReceiverType result actuallyUsedType |
	expectedReceiverType := messageNode coercionType first.
	receiverValue := nil.
	expectedReceiverType isVoidType ifFalse: [ 
		receiverValue := messageNode coercionRule first
			convertSSAValue: (messageNode receiver generateSSACodeWith: builder)
			to: expectedReceiverType with: builder at: messageNode.
	].
	
	arguments := messageNode arguments collectWithIndex: [ :arg :index |
		(messageNode coercionRule second at: index)
			convertSSAValue: (arg generateSSACodeWith: builder)
			to: (messageNode coercionType second at: index) with: builder at: messageNode.
	].
	
	result := messageMethod generateSSAMessageSend: messageNode withReceiver: receiverValue arguments: arguments withBuilder: builder.
	
	"For dependent InstanceType/MetaType."
	actuallyUsedType := messageNode valueType ssaType.
	result type ~~ actuallyUsedType ifTrue: [
		self assert: (result type isPointerType and: [ actuallyUsedType isPointerType ]).
		result := builder bitCast: result target: actuallyUsedType
	].

	^ result
]

{ #category : #accessing }
SYMLSendMessageMacro >> messageMethod [
	^ messageMethod
]

{ #category : #accessing }
SYMLSendMessageMacro >> messageMethod: anObject [
	messageMethod := anObject
]

{ #category : #'macro compilation' }
SYMLSendMessageMacro >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| analyzedMessage receiverType argumentTypes expectedReceiverType expectedArgumentTypes receiverCoercionRule argumentsCoercionRule |
	analyzedMessage := message withAnalyzedReceiverAndArgumentsInEnvironment: environment.
	messageMethod ifNil: [
		expectedReceiverType := nil.
		expectedArgumentTypes := nil.
		self halt.
	] ifNotNil: [
		messageMethod ensureSemanticAnalysis.
		expectedReceiverType := messageMethod receiverType.
		expectedArgumentTypes := messageMethod bindedFunctionType arguments.
	].

	receiverCoercionRule := nil.
	receiverType := analyzedMessage receiver ifNotNil: [:receiver | receiver evaluateTypeInEnvironment: environment].
	expectedReceiverType isVoidType ifFalse: [ 
		receiverCoercionRule := receiverType node: analyzedMessage receiver coercedImplicitlyInto: expectedReceiverType at: message.
	].

	argumentTypes := analyzedMessage arguments collect: [ :argument | argument evaluateTypeInEnvironment: environment ].
	argumentsCoercionRule := argumentTypes collectWithIndex: [:argumentType :index |
		argumentType node: analyzedMessage receiver coercedImplicitlyInto: (expectedArgumentTypes at: index) at: message.
	].

	^ analyzedMessage copy
		metaMethod: self;
		valueType: (messageMethod ifNotNil: [messageMethod returnTypeForReceiverType: receiverType argumentTypes: argumentTypes ] ifNil: [message receiver receiverType]);
		coercionType: { expectedReceiverType . expectedArgumentTypes };
		coercionRule: { receiverCoercionRule . argumentsCoercionRule };
		yourself
]
