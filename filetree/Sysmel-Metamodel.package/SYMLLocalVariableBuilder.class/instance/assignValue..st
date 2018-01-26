meta methods
assignValue: theInitialValue
	<compileTime>
	<lazy>
	<rewrite>
	| environment |
	self assert: theInitialValue type isAPSGNode.
	
	environment := theInitialValue environment.
	initialValue := theInitialValue value semanticAnalysisInEnvironment: theInitialValue environment.
	type ifNil: [
		type := (initialValue evaluateTypeInEnvironment: environment) valueType cleanType.
	].

	^ self createInitialValueNodeAt: initialValue position inEnvironment: theInitialValue environment
	