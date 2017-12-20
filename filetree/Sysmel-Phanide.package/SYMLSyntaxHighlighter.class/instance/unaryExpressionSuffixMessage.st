accessing
unaryExpressionSuffixMessage
	^ super unaryExpressionSuffixMessage ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle method token: token).
		token
	]