as yet unclassified
coerceIntegerType: firstInteger withIntegerType: secondInteger
	<coerce: #IntegerType with: #IntegerType>
	firstInteger == secondInteger ifTrue: [ ^ firstInteger ].
	(firstInteger size < 4 and: [ secondInteger size < 4 ]) ifTrue: [ ^ target int32Type ].
	
	self halt.