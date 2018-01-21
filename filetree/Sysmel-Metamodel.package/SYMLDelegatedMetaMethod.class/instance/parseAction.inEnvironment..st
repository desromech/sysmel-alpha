parsing
parseAction: action inEnvironment: environment
	| actionFunction |
	(action isImplicitContextMessageNode and: [action arguments size = 1]) ifFalse: [
		self error: 'Expected an selector for the action name' at: action
	].

	actionFunction := action arguments first analyzeAndEvaluateInEnvironment: environment.
	self install: actionFunction value asSysmelCompileTimeFunction for: action selector