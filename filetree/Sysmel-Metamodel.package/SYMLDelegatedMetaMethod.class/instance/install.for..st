parsing
install: function for: selector
	selector == #evaluation: ifTrue: [ evaluationFunction := function . ^ self ].
	selector == #semanticAnalysis: ifTrue: [ semanticAnalysisFunction := function . ^ self ].
	selector == #codeGeneration: ifTrue: [ codeGenerationFunction := function . ^ self ].
	self error: 'Unsupported meta method action'
	