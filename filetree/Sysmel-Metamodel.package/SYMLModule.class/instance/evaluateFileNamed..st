evaluating
evaluateFileNamed: aFileName
	| fileEnvironment |
	fileEnvironment := self newEvaluationEnvironment.
	^ self evaluateFileNamed: aFileName inContext: fileEnvironment