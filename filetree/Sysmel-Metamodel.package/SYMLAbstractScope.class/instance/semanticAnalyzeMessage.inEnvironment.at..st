meta methods
semanticAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| metaMethod selector |
	selector := messageNode selector.
	metaMethod := self findRecursivelyMetaMethodForSelector: selector receiver: messageNode receiver arguments: messageNode arguments inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNil: [
		self error: 'Failed to find meta method {1}.' format: {selector printString} at: aSourcePosition
	].

	^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition