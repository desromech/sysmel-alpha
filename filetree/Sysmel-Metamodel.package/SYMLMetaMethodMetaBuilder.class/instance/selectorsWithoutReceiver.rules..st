accessing
selectorsWithoutReceiver: someSelectors rules: someRules
	<compileTime>
	<lazy>
	| definitionEnvironment |
	definitionEnvironment := someSelectors environment findProgramEntityDefinitionScope.
	^ self addRules: someRules evaluate toSelectors: someSelectors evaluate value hasReceiver: false in: definitionEnvironment