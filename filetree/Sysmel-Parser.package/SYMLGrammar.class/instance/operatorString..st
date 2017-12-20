as yet unclassified
operatorString: aString
	^ anyBinaryOperator >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ result inputValue ~= aString]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected a special operator' context: stream
		] ifFalse: [
			result
		]
	]