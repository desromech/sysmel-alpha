errors
error: anErrorString at: aSourcePosition
	^ SYMLSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: self;
		signal