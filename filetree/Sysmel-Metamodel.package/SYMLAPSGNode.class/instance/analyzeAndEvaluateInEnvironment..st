meta evaluation
analyzeAndEvaluateInEnvironment: anEnvironment
	^ (self semanticAnalysisInEnvironment: anEnvironment) evaluateInEnvironment: anEnvironment