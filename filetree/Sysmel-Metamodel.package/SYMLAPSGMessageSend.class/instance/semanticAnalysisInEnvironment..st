meta evaluation
semanticAnalysisInEnvironment: anEnvironment
	metaMethod ifNotNil: [ ^ self ].
	^ anEnvironment semanticAnalyzeMessage: self at: self