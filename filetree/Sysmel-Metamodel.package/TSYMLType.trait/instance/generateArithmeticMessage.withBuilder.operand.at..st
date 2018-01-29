arithmetic
generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode
	self error: 'Unsupported arithmetic unary operation {1} for values of type {2} ' format: { selector . self asString } at: messageNode