accessing
literalArrayBinaryOperator
	^ super literalArrayBinaryOperator ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]