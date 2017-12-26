as yet unclassified
evaluateInEnvironment: anEnvironment withReceiver: aReceiver
	^ anEnvironment send: selector toReceiver: aReceiver withArguments: (anEnvironment wrapAPSGNodes: arguments) at: self