as yet unclassified
evaluateInEnvironment: anEnvironment
	^ (self buildAPSG: (anEnvironment apsgBuilder)) evaluateInEnvironment: anEnvironment