accessing
findWithType: functionType ifAbsentPut: aBlock
	| result |
	functions do: [ :function |
		function functionType = functionType ifTrue: [ ^ function ]
	].

	result := aBlock value.
	functions add: result.
	^ result