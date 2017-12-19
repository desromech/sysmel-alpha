accessing
singleLineComment
	^ super singleLineComment token ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle singleLineComment token: token)
	]