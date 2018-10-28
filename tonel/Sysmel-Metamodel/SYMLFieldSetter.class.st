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
	field setReceiver: receiver value: coercedValue unwrapSysmelValue.
	^ coercedValue
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
	
	field parent ensureConcreteStructureSSAType.
	^ field setSSAReceiver: receiverValue value: newFieldValue with: builder
]

{ #category : #'macro compilation' }
SYMLFieldSetter >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| receiver value valueType coercionRule coercionType |
	receiver := message receiver semanticAnalysisInEnvironment: environment.
	value := message arguments first semanticAnalysisInEnvironment: environment.
	valueType := value evaluateTypeInEnvironment: environment.
	coercionRule := valueType node: value coercedImplicitlyInto: field type at: aPosition.
	coercionType := field type.
	
	^ message copy
		receiver: receiver;
		arguments: { value };
		coercionType: coercionType;
		coercionRule: coercionRule;
		metaMethod: self;
		valueType: coercionType;
		yourself
]
