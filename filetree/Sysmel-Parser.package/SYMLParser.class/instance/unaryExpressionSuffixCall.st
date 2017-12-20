accessing
unaryExpressionSuffixCall
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		SYMLASTFunctionApplication new
			position: tokens first;
			tokens: { tokens first . tokens last };
			arguments: tokens second;
			yourself
	]