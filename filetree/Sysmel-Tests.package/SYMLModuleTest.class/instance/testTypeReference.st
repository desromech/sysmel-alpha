tests
testTypeReference
	| value |
	value := module evaluateSource: 'Void'.
	self assert: value type isMetaType.
	self assert: value value equals: target voidType.