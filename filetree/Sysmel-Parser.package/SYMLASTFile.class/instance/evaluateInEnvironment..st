as yet unclassified
evaluateInEnvironment: anEnvironment
	| result |
	result := nil.
	expressions do: [ :expr | result := expr evaluateInEnvironment: anEnvironment ].
	^ result