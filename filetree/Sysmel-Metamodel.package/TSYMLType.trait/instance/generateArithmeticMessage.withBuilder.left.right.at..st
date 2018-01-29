arithmetic
generateArithmeticMessage: selector withBuilder: builder left: left right: right at: messageNode
	self error: 'Unsupported arithmetic binary operation {1} for values of type {2} ' format: { selector . self asString } at: messageNode