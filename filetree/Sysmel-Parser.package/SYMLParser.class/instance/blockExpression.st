accessing
blockExpression
	^ super blockExpression ==> [ :tokens |
		SYMLASTBlock new
			tokens: { tokens first . tokens last };
			position: tokens first;
			pragmas: tokens second;
			expressions: tokens third;
			yourself
	]