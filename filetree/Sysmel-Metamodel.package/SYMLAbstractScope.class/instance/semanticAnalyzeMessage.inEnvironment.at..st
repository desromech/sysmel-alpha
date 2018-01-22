meta methods
semanticAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| metaMethod |
	metaMethod := self findRecursivelyMetaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNil: [
		self error: 'Failed to find meta method {1}.' format: {messageNode selector printString} at: aSourcePosition
	].

	^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition