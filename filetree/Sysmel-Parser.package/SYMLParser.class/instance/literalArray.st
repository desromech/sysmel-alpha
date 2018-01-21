accessing
literalArray
	^ super literalArray ==> [ :tokens |
		SYMLASTLiteralArrayValue new
			tokens: { tokens first . tokens last  };
			position: tokens first;
			elements: tokens second;
			yourself
	]