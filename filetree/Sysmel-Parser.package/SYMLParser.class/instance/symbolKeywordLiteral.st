accessing
symbolKeywordLiteral
	^ super symbolKeywordLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]