as yet unclassified
coerceLiteralIntegerType: literalIntegerType withIntegerType: integerType
	<coerce: #LiteralIntegerType with: #IntegerType>
	integerType size < 4 ifTrue: [ ^ target int32Type ].
	^ integerType