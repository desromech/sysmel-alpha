accessing
pragmaChainKeywordMessage
	^ super pragmaChainKeywordMessage ==> [ :tokens |
		tokens do: [ :pair |
			self commands
				add: (PhanideHighlightCommandStyle pragma token: pair first)
		]
	]