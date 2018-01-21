accessing
symbolIdentifierLiteral
	^ super symbolIdentifierLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]