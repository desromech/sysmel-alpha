accessing
pragmaChainUnaryMessage
	^ super pragmaChainUnaryMessage ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle pragma token: token)
	]