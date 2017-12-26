as yet unclassified
evaluateInEnvironment: anEnvironment
	^ anEnvironment
		send: #applyWithArguments:
		toReceiver: (anEnvironment wrapASTNode: function)
		withArguments: {anEnvironment wrapASTNode: arguments}
		at: self