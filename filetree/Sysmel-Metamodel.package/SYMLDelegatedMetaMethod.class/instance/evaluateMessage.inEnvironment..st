meta methods
evaluateMessage: messageNode inEnvironment: anEnvironment
	^ evaluationFunction valueWithReceiver: self arguments: { messageNode . anEnvironment} 