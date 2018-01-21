meta methods
evaluateMessage: messageNode inEnvironment: anEnvironment
	^ evaluationFunction cull: messageNode cull: anEnvironment