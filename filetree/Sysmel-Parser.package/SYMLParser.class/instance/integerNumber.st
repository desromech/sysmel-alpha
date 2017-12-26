accessing
integerNumber
	^ super integerNumber ==> [ :token | SYMLASTLiteralIntegerValue new
			tokens: { token };
			position: token;
			value: (self parseIntegerValue: token inputValue);
			yourself
			]