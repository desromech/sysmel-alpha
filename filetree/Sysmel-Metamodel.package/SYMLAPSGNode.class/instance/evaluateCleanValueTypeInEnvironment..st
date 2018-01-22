meta evaluation
evaluateCleanValueTypeInEnvironment: anEnvironment
	^ (self evaluateTypeInEnvironment: anEnvironment) ifNotNil: [:type | type valueType cleanType]