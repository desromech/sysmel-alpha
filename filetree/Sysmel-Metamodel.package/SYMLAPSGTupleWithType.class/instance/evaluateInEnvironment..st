meta evaluation
evaluateInEnvironment: anEnvironment
	^ (elements collect: [ :el | el evaluateInEnvironment: anEnvironment ]) sysmelValueWithType: type