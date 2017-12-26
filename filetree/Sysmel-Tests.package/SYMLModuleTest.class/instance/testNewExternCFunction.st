tests
testNewExternCFunction
	| functionBuilder group |
	functionBuilder := module evaluateSource: 'function main externC () -> Void'.
	group := module globalNamespace lookSymbol: #main.
	self assert: group isFunction.
	self assert: group equals: functionBuilder value function.