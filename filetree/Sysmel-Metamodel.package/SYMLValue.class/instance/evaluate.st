public access
evaluate
	^ environment ifNotNil: [ self evaluateInEnvironment: environment ] ifNil: [ self ]