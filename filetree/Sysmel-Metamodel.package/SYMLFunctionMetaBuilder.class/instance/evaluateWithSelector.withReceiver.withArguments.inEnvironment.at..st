accessing
evaluateWithSelector: aSelector withReceiver: aReceiver withArguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	self assert: theArguments isEmpty.
	
	^ (SYMLFunctionBuilder new definitionEnvironment: anEnvironment findProgramEntityDefinitionScope; name: aSelector) sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment