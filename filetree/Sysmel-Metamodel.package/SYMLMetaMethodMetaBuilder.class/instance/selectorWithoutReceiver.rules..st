accessing
selectorWithoutReceiver: aSelector rules: someRules
	<compileTime>
	<lazy>
	| definitionEnvironment |
	definitionEnvironment := aSelector environment findProgramEntityDefinitionScope.
	^ self addRules: someRules evaluate toSelectors: { aSelector evaluate } hasReceiver: false in: definitionEnvironment