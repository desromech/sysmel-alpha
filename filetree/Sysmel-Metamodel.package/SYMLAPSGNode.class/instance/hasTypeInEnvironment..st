testing
hasTypeInEnvironment: anEnvironment
	^ (self evaluateTypeInEnvironment: anEnvironment) isNotNil
	