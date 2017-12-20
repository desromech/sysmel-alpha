accessing
identifierExpression
	^ super identifierExpression ==> [ :token |
		SYMLASTIdentifierReference new
			position: token;
			tokens: { token };
			value: token inputValue asSymbol;
			yourself
	]