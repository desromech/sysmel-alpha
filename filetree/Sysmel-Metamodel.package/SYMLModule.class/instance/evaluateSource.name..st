evaluating
evaluateSource: aSourceString name: aSourceName
	| lexicalScope |
	lexicalScope := self newEvaluationEnvironment.
	^ self evaluateSource: aSourceString name: aSourceName inContext: lexicalScope