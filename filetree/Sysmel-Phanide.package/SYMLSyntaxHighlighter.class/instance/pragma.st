accessing
pragma
	^ super pragma ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle pragma token: tokens first);
			add: (PhanideHighlightCommandStyle pragma token: tokens last)
	]