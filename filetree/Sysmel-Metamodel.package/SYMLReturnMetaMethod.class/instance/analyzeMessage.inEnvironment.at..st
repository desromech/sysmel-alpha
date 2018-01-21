meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| returnValue returnValueType expectedReturnValue |
	self assert: messageNode arguments size = 1.
	
	"Check the return type."
	returnValue := 	messageNode arguments first semanticAnalysisInEnvironment: anEnvironment.
	returnValueType := returnValue evaluateCleanValueTypeInEnvironment: anEnvironment.
	expectedReturnValue := anEnvironment returnType.
	returnValueType coercedImplicitlyNode: returnValue into: expectedReturnValue at: aSourcePosition.
	
	^ messageNode copy
		metaMethod: self;
		arguments: { returnValue };
		coercionType: expectedReturnValue;
		valueType: anEnvironment compilationTarget voidType;
		yourself