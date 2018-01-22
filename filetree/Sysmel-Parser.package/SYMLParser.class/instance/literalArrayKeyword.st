accessing
literalArrayKeyword
	^ super literalArrayKeyword ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]