as yet unclassified
evaluateInEnvironment: anEnvironment
	| result |
	result := nil.
	elements do: [ :expr | result := expr evaluateInEnvironment: anEnvironment ].
	^ result