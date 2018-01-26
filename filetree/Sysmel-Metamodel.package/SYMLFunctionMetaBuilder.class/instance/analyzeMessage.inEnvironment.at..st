accessing
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| functionBuilder |
	self assert: messageNode arguments isEmpty.
	
	functionBuilder := SYMLFunctionBuilder new
		definitionEnvironment: anEnvironment findProgramEntityDefinitionScope;
		sourcePosition: aSourcePosition;
		name: messageNode selector;
		yourself.
	^ messageNode buildLiteralWithValue: (functionBuilder sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment)