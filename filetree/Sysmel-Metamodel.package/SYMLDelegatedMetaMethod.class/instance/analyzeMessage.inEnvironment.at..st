meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	^ semanticAnalysisFunction valueWithReceiver: self arguments: { messageNode . anEnvironment . aSourcePosition}