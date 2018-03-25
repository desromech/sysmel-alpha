meta methods
assignValue: aDefinition
	<compileTime>
	
	| scope |
	aDefinition type isAPSGNode ifFalse: [
		name ifNotNil: [ 
			self error: 'Expected an APSG/AST node for definition of structure {1}.' format: {name}
		] ifNil: [
			self error: 'Expected an APSG/AST node for definition of structure.'
		]
	].

	scope := (SYMLStructureScope parent: aDefinition environment)
		structure: self;
		yourself.
	aDefinition value analyzeAndEvaluateInEnvironment: scope.
	^ self asSysmelValueInEnvironment: aDefinition environment