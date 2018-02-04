evaluating
evaluateLanguageKernelFileNamed: aFileName
	<compileTime>
	| fileEnvironment |
	fileEnvironment := self newLanguageKernelEnvironment.
	^ self evaluateFileNamed: aFileName value inContext: fileEnvironment