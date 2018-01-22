accessing
literalArrayKeyword
	^ super literalArrayKeyword ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]