accessing
innerLiteralArrayLiteral
	^ super innerLiteralArrayLiteral ==> [ :tokens |
		SYMLASTLiteralArrayValue new
			tokens: { tokens first . tokens last  };
			position: tokens first;
			elements: tokens second;
			yourself
	]