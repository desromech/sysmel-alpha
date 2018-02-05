as yet unclassified
analyzeArgumentsInEnvironment: anEnvironment
	^ self copy
		arguments: (arguments collect: [ :arg |
			arg semanticAnalysisInEnvironment: anEnvironment
		]);
		argumentsAreAnalyzed: true;
		yourself.