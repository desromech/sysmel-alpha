arithmetic
resultTypeForArithmeticMessage: selector at: node
	self error: 'Unsupported arithmetic operator {1} for values of type {2} ' format: { selector . self asString } at: node