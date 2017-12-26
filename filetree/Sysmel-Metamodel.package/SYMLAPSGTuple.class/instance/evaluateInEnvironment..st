as yet unclassified
evaluateInEnvironment: anEnvironment
	self flag: 'TODO: Use a tuple type'.
	self halt.
	^ elements collect: [ :el | el evaluateInEnvironment: anEnvironment ]