tests
testRedeclareExternCFunction
	| declaration redeclaration |
	declaration := module evaluateSource: 'function main externC () -> Void'.
	redeclaration := module evaluateSource: 'function main externC () -> Void'.
	
	self assert: redeclaration value function equals: declaration value function.