accessing
floatNumber
	^ super floatNumber ==> [ :token | SYMLASTLiteralFloatValue new
			tokens: { token };
			position: token;
			value: (self parseFloatValue: token inputValue);
			yourself
			]