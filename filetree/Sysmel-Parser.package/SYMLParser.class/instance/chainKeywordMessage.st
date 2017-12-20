accessing
chainKeywordMessage
	^ super chainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		SYMLASTMessageSend new
			position: list first first;
			tokens: (list collect: #first);
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]