tests
testNewFunction
	| functionBuilder group |
	functionBuilder := module evaluateSource: 'function main () -> Void'.
	group := module globalNamespace lookSymbol: #main.
	self assert: group isFunctionGroup.
	self assert: group functions first equals: functionBuilder value function.