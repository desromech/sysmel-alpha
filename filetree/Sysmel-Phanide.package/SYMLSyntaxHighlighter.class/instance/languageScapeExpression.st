accessing
languageScapeExpression
	^ super languageScapeExpression ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle keyword token: tokens first);
			add: (PhanideHighlightCommandStyle keyword token: tokens second).
		SYMLScapedLanguageCompiler tryToStyle: tokens third language: tokens second inputValue into: commands.
		tokens
	]