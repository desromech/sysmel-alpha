accessing
literalArrayBinaryOperator
	^ super literalArrayBinaryOperator ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]