tokens
genericBinaryOperator
	^ anyBinaryOperator >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ SpecialOperators includes: result inputValue ]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected a generic operator, not an special.' context: stream
		] ifFalse: [
			result
		]
	]