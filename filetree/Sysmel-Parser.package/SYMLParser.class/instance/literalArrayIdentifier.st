accessing
literalArrayIdentifier
	^ super literalArrayIdentifier ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue asSymbol);
			yourself
	]