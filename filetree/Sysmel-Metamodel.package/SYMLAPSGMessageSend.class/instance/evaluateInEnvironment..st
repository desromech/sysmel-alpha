as yet unclassified
evaluateInEnvironment: anEnvironment
	^ self evaluateInEnvironment: anEnvironment withReceiver: (anEnvironment wrapAPSGNode: receiver)