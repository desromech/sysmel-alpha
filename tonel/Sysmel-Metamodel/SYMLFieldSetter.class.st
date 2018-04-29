Class {
	#name : #SYMLFieldSetter,
	#superclass : #SYMLFieldAccessor,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLFieldSetter >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver value coercedValue receiverValue |
	receiverValue := message receiver evaluateInEnvironment: anEnvironment.
	receiver := receiverValue unwrapSysmelValue.
	value := message arguments first evaluateInEnvironment: anEnvironment.
	coercedValue := message coercionRule convertValue: value into: message coercionType at: message position.
	receiver slots at: field slotIndex + 1 put: coercedValue value.
	^ receiverValue
]

{ #category : #'macro compilation' }
SYMLFieldSetter >> generateMessage: messageNode ssaCodeWith: builder [
	| receiverValue newFieldValue |
	receiverValue := messageNode receiver generateSSACodeWith: builder.
	newFieldValue := messageNode coercionRule
		convertSSAValue: (messageNode arguments first generateSSACodeWith: builder)
		to: messageNode coercionType
		with: builder
		at: messageNode.
	
	^ field setSSAReceiver: receiverValue value: newFieldValue with: builder
]

{ #category : #'macro compilation' }
SYMLFieldSetter >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| receiver value valueType coercionRule |
	receiver := message receiver semanticAnalysisInEnvironment: environment.
	value := message arguments first semanticAnalysisInEnvironment: environment.
	valueType := value evaluateTypeInEnvironment: environment.
	coercionRule := valueType node: value coercedImplicitlyInto: field type at: aPosition.
	
	^ message copy
		receiver: receiver;
		arguments: { value };
		coercionType: field type;
		coercionRule: coercionRule;
		metaMethod: self;
		valueType: (message receiver evaluateTypeInEnvironment: environment);
		yourself
]
