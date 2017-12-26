tests
testLiteralAdd
	| value |
	value := module evaluateSource: '1+1'.
	self assert: value value equals: 2.
	self assert: value type equals: target literalIntegerType.
