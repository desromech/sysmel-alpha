meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| localBuilder |
	self assert: messageNode arguments isEmpty.
	
	localBuilder := SYMLLocalVariableBuilder new
		definitionEnvironment: anEnvironment findLocalDefinitionScope;
		sourcePosition: aSourcePosition;
		name: messageNode selector;
		yourself.
	^ messageNode buildLiteralWithValue: (localBuilder sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment)