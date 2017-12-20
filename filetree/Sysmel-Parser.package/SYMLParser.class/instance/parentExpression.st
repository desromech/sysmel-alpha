accessing
parentExpression
	^ super parentExpression ==> [ :tokens |
		SYMLASTParentExpression new
			position: tokens first;
			tokens: { tokens first . tokens last };
			expression: tokens second;
			yourself
	]