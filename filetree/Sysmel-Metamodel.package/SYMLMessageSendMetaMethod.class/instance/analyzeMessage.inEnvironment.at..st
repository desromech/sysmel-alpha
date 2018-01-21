meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| receiver receiverType evaluatedValue |
	receiver := messageNode receiver.
	receiverType := receiver evaluateTypeInEnvironment: anEnvironment.
	
	(receiverType isCompilerObjectType or: [receiverType isMetaType]) ifTrue: [
		evaluatedValue := self evaluateMessage: messageNode inEnvironment: anEnvironment.
		^ messageNode buildLiteralWithValue: evaluatedValue
	].

	^ messageNode copy
		metaMethod: self;
		valueType: anEnvironment compilationTarget voidType;
		yourself