accessing
languageScapeExpression
	^ super languageScapeExpression ==> [ :tokens |
		SYMLASTLanguageScape new
			tokens: { tokens };
			position: tokens first;
			languageName: tokens second inputValue asSymbol;
			sourceCode: tokens third inputValue;
			sourceCodePosition: tokens third;
			yourself
	]