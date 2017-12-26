accessing
stringLiteral
	^ super stringLiteral ==> [ :token |
		SYMLASTLiteralStringValue new
			tokens: { token };
			position: token;
			value: (self parseCString: token inputValue);
			yourself
	]