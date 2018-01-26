meta methods
evaluateCompileTimeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition	
	| evaluatedValue |
	evaluatedValue := self evaluateMessage: messageNode inEnvironment: anEnvironment.
	rewrite ifTrue: [ ^ evaluatedValue ].
	^ messageNode buildLiteralWithValue: evaluatedValue
