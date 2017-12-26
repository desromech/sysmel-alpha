meta methods
applyWithArguments: argumentNodes
	<compileTime>
	<lazy>
	
	| evaluationEnvironment argumentName argumentType |
	evaluationEnvironment := argumentNodes environment.
	argumentNodes type isAPSGNode ifFalse: [
		self error: 'Expected an APSG node.'
	].

	argumentNodes value isTupleNode ifFalse: [ 
		self error: 'Expected an APSG tuple.'
	].

	arguments := argumentNodes value elements collect: [ :arg |
		arg isMessageNode ifFalse: [
			self error: 'Expected a message send to describe a function argument.' at: arg.
		].
	
		arg receiver ifNotNil: [ 
			self error: 'Function argument description must not have a receiver.' at: arg.
		].

		arg arguments size ~= 1 ifTrue: [ 
			self error: 'Function argument description must have only a single keyword.' at: arg.
		].
	
		argumentName := arg selector allButLast asSymbol.
		argumentType := arg arguments first evaluateInEnvironment: evaluationEnvironment.
		argumentType type isMetaType ifFalse: [
			self error: 'Expected a type for argument {1}' format: { argumentName } at: arg arguments first
		].
		
		argumentName -> argumentType value
	].
