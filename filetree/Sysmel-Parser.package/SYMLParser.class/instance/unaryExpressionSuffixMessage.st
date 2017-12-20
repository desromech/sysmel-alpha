accessing
unaryExpressionSuffixMessage
	^ super unaryExpressionSuffixMessage ==> [ :selector |
		SYMLASTMessageSend new
			position: selector;
			tokens: { selector };
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]