coercion
arithmeticCoerceWith: other
	(ArithmeticCoercionTable coerce: self with: other) ifNotNil: [ :result | ^ result ].
	^ super arithmeticCoerceWith: other