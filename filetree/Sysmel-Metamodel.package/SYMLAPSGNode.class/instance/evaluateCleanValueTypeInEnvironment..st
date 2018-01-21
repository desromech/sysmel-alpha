meta evaluation
evaluateCleanValueTypeInEnvironment: anEnvironment
	^ (self evaluateTypeInEnvironment: anEnvironment) valueType cleanType