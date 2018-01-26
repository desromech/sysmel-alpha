meta methods
evaluateCompileTimeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition	
	| evaluatedValue |
	evaluatedValue := self evaluateMessage: messageNode inEnvironment: anEnvironment.
	rewrite ifTrue: [
		self assert: evaluatedValue type isAPSGNode.
		^ evaluatedValue value
	].
	^ messageNode buildLiteralWithValue: evaluatedValue
