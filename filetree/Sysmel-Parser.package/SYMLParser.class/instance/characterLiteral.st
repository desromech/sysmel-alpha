accessing
characterLiteral
	^ super characterLiteral ==> [ :token |
		SYMLASTLiteralCharacterValue new
			tokens: { token };
			position: token;
			value: (self parseCCharacter: token inputValue);
			yourself
	]