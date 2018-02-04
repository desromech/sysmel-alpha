meta evaluation
semanticAnalysisInEnvironment: anEnvironment
	| analyzedElements |
	analyzedElements := elements collect: [ :element | (element semanticAnalysisInEnvironment: anEnvironment) asNodeForSequenceElementIn: anEnvironment ].
	^ SYMLAPSGSequenceWithType new
		position: self;
		elements: analyzedElements;
		valueType: (analyzedElements ifEmpty: [anEnvironment compilationTarget voidType] ifNotEmpty: [analyzedElements last evaluateTypeInEnvironment: anEnvironment]);
		yourself