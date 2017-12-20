accessing
postfix: operation operate: operand
	^ SYMLASTMessageSend new
		tokens: {operation};
		position: operation;
		selector: ('postfix-' , operation inputValue) asSymbol;
		receiver: operand;
		arguments: #();
		yourself
