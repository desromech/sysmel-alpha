accessing
chainUnaryMessage
	^ super chainUnaryMessage ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle method token: token).
		token
	]