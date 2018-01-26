converting
createInitialValueNodeAt: aPosition inEnvironment: anEnvironment
	| variableReferenceNode |
	variableReferenceNode := SYMLAPSGIdentifierWithBinding new
			position: aPosition;
			value: name;
			binding: self binding;
			yourself.

	initialValue ifNil: [ ^ variableReferenceNode ].

^ (SYMLAPSGMessageSend new	
		position: aPosition;
		receiver: variableReferenceNode;
		selector: #assignValue:;
		arguments: { initialValue };
		yourself) semanticAnalysisInEnvironment: anEnvironment