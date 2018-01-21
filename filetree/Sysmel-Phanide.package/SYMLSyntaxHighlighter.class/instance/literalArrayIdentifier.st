accessing
literalArrayIdentifier
	^ super literalArrayIdentifier ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle symbol token: token)
	]