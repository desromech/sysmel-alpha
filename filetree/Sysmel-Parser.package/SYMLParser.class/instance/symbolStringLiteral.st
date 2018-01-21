accessing
symbolStringLiteral
	^ super symbolStringLiteral ==> [ :token |
		SYMLASTLiteralSymbolValue new
			tokens: { token };
			position: token;
			value: (self parseCString: token inputValue allButFirst) asSymbol;
			yourself
	]