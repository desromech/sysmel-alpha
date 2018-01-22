meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	rules do: [ :rule |
		(rule matchesMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition) ifTrue: [ 
			^ rule analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
		]
	].
	self error: 'Failed to analyze message.'