meta evaluation
semanticAnalysisInEnvironment: anEnvironment
	| analyzedElements |
	analyzedElements := elements collect: [ :element | (element semanticAnalysisInEnvironment: anEnvironment) asNodeForSequenceElementIn: anEnvironment ].
	^ SYMLAPSGSequenceWithType new
		position: self;
		elements: analyzedElements;
		valueType: (analyzedElements last evaluateTypeInEnvironment: anEnvironment);
		yourself