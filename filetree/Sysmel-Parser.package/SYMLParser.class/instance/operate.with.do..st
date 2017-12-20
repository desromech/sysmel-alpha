accessing
operate: left with: right do: operation
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: operation inputValue asSymbol;
		receiver: left;
		arguments: {right};
		yourself
