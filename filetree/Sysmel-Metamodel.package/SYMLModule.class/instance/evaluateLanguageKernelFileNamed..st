evaluating
evaluateLanguageKernelFileNamed: aFileName
	| fileEnvironment |
	fileEnvironment := self newLanguageKernelEnvironment.
	^ self evaluateFileNamed: aFileName inContext: fileEnvironment