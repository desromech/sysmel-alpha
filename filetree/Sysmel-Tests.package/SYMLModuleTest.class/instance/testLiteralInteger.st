tests
testLiteralInteger
	| value |
	value := module evaluateSource: '1'.
	self assert: value value equals: 1.
	self assert: value type equals: target literalIntegerType.
