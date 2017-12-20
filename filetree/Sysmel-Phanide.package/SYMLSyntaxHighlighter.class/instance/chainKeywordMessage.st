accessing
chainKeywordMessage
	^ super chainKeywordMessage ==> [ :tokens |
		tokens do: [ :pair |
			self commands add: (PhanideHighlightCommandStyle method token: pair first).
		].
		tokens
	]