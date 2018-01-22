meta methods
canAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	rules do: [ :rule |
		(rule matchesMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition) ifTrue: [ 
			^ true
		]
	].
	^ false