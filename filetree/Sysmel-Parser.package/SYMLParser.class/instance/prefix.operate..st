accessing
prefix: operation operate: operand
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: ('prefix-' , operation inputValue) asSymbol;
		receiver: operand;
		arguments: #();
		yourself
