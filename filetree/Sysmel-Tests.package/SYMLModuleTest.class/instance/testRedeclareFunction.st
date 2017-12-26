tests
testRedeclareFunction
	| declaration redeclaration |
	declaration := module evaluateSource: 'function main () -> Void'.
	redeclaration := module evaluateSource: 'function main () -> Void'.
	
	self assert: redeclaration value function equals: declaration value function.