accessing
multiLineComment
	^ super multiLineComment token ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle multiLineComment token: token)
	]