accessing
applyWithArguments: argumentNodes
	<compileTime>
	<lazy>
	^ SYMLFunctionBuilder new
		definitionEnvironment: argumentNodes environment findProgramEntityDefinitionScope;
		applyWithArguments: argumentNodes