meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| receiver receiverType |
	receiver := messageNode receiver.
	receiverType := receiver evaluateTypeInEnvironment: anEnvironment.
	
	(receiverType isCompilerObjectType or: [receiverType isMetaType]) ifTrue: [
		^ self evaluateCompileTimeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition	
	].

	^ messageNode copy
		metaMethod: self;
		valueType: anEnvironment compilationTarget voidType;
		yourself