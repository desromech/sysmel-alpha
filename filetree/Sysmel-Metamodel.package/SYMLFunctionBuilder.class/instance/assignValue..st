meta methods
assignValue: aDefinition
	<compileTime>
	aDefinition type isAPSGNode ifFalse: [
		name ifNotNil: [ 
			self error: 'Expected an APSG/AST node for definition of function {1}.' format: {name}
		] ifNil: [
			self error: 'Expected an APSG/AST node for definition of function.'
		]
	].

	self function definition ifNotNil: [
		name ifNotNil: [ 
			self error: 'Redefining function {1}.' format: {name}
		] ifNil: [
			self error: 'Redefining function.'
		]
	].

	^ self function
		definition: aDefinition value;
		yourself
	