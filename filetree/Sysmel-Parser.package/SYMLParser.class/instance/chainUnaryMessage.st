accessing
chainUnaryMessage
	^ super chainUnaryMessage ==> [ :selector |
		SYMLASTMessageSend new
			tokens: {selector};
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]