accessing
symbolOperatorLiteral
	^ super symbolOperatorLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (token inputValue allButFirst asSymbol);
			yourself
	]