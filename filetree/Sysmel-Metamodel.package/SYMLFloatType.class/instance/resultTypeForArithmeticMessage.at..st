arithmetic
resultTypeForArithmeticMessage: selector at: node
	(ArithmeticSelectors includes: selector) ifTrue: [ ^ self ].
	(ComparisonSelectors includes: selector) ifTrue: [ ^ target booleanType ].
	^ super resultTypeForArithmeticMessage: selector at: node