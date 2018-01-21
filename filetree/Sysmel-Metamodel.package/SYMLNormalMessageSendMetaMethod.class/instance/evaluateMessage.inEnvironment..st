meta methods
evaluateMessage: messageNode inEnvironment: anEnvironment
	| receiver arguments |
	receiver := messageNode receiver evaluateInEnvironment: anEnvironment.
	arguments := messageNode arguments collect: [:arg | arg analyzeAndEvaluateInEnvironment: anEnvironment].
	^ (receiver value perform: messageNode selector withArguments: arguments) asSysmelValueInEnvironment: anEnvironment