tokens
anyBinaryOperator
	^ self operator: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus