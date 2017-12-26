as yet unclassified
evaluateInEnvironment: anEnvironment
	^ anEnvironment send: #assignValue:
		toReceiver: (anEnvironment wrapASTNode: reference)
		withArguments: { anEnvironment wrapASTNode: value }
		at: self