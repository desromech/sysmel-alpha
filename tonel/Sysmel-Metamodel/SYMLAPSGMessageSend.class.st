Class {
	#name : #SYMLAPSGMessageSend,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'selector',
		'receiver',
		'arguments',
		'metaMethod',
		'valueType',
		'coercionType',
		'coercionRule',
		'argumentsAreAnalyzed',
		'isReceiverAnalyzed',
		'hasIncompleteSemanticAnalysis',
		'analysisEnvironment'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGMessageSend >> analysisEnvironment [
	^ analysisEnvironment
]

{ #category : #accessing }
SYMLAPSGMessageSend >> analysisEnvironment: anObject [
	analysisEnvironment := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> analyzeAndEvaluateInEnvironment: anEnvironment [
	metaMethod ifNotNil: [ ^ self evaluateInEnvironment: anEnvironment ].
	^ anEnvironment analyzeAndEvaluateMessage: self at: position
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> analyzeArgumentsInEnvironment: anEnvironment [
	^ self copy
		arguments: (arguments collect: [ :arg |
			arg semanticAnalysisInEnvironment: anEnvironment
		]);
		argumentsAreAnalyzed: true;
		yourself.
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> analyzeReceiverInEnvironment: anEnvironment [
	^ self copy
		receiver: (receiver semanticAnalysisInEnvironment: anEnvironment);
		isReceiverAnalyzed: true;
		yourself.
]

{ #category : #accessing }
SYMLAPSGMessageSend >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLAPSGMessageSend >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLAPSGMessageSend >> argumentsAreAnalyzed: anObject [
	argumentsAreAnalyzed := anObject
]

{ #category : #accessing }
SYMLAPSGMessageSend >> coercionRule [
	^ coercionRule
]

{ #category : #accessing }
SYMLAPSGMessageSend >> coercionRule: anObject [
	coercionRule := anObject
]

{ #category : #accessing }
SYMLAPSGMessageSend >> coercionType [
	^ coercionType
]

{ #category : #accessing }
SYMLAPSGMessageSend >> coercionType: anObject [
	coercionType := anObject
]

{ #category : #'as yet unclassified' }
SYMLAPSGMessageSend >> concretizeSemanticAnalysisInEnvironment: anEnvironment [
	| result |
	hasIncompleteSemanticAnalysis ifTrue: [ 
		result := self copy
			receiver: (receiver ifNotNil: [receiver concretizeSemanticAnalysisInEnvironment: anEnvironment]);
			arguments: (arguments collect: [:arg | arg concretizeSemanticAnalysisInEnvironment: anEnvironment]);
			hasIncompleteSemanticAnalysis: false.
		^ result metaMethod
			ifNotNil: [ metaMethod semanticAnalyzeMessage: result inEnvironment: anEnvironment at: result ]
			ifNil: [ result semanticAnalysisInEnvironment: anEnvironment ]
			
	].

	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> evaluateInEnvironment: anEnvironment [
	hasIncompleteSemanticAnalysis ifTrue: [
		^ (self concretizeSemanticAnalysisInEnvironment: anEnvironment) evaluateInEnvironment: anEnvironment
	].

	^ metaMethod evaluateMessage: self inEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> evaluateTypeInEnvironment: anEnvironment [
	^ valueType
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> generateSSACodeWith: builder [
	builder withDebugPosition: self position do: [
		^ metaMethod generateMessage: self ssaCodeWith: builder
	]
]

{ #category : #testing }
SYMLAPSGMessageSend >> hasAnalyzedArguments [
	^ argumentsAreAnalyzed
]

{ #category : #accessing }
SYMLAPSGMessageSend >> hasIncompleteSemanticAnalysis [
	^ hasIncompleteSemanticAnalysis
]

{ #category : #accessing }
SYMLAPSGMessageSend >> hasIncompleteSemanticAnalysis: anObject [
	hasIncompleteSemanticAnalysis := anObject
]

{ #category : #initialization }
SYMLAPSGMessageSend >> initialize [
	super initialize.
	argumentsAreAnalyzed := false.
	isReceiverAnalyzed := false.
	hasIncompleteSemanticAnalysis := false.
]

{ #category : #accessing }
SYMLAPSGMessageSend >> inspectorChildren [
	^ { selector .
		receiver .
		#arguments -> arguments .
	}
]

{ #category : #testing }
SYMLAPSGMessageSend >> isImplicitContextMessageNode [
	^ receiver isNil
]

{ #category : #testing }
SYMLAPSGMessageSend >> isLiteralMessage [
	(receiver isNil or: [receiver isLiteralNode not]) ifTrue: [ ^ false ].
	arguments do: [ :arg |
		arg isLiteralNode ifFalse: [ ^ false ]
	].

	^ true
]

{ #category : #testing }
SYMLAPSGMessageSend >> isMessageNode [
	^ true
]

{ #category : #accessing }
SYMLAPSGMessageSend >> isReceiverAnalyzed [
	^ isReceiverAnalyzed
]

{ #category : #accessing }
SYMLAPSGMessageSend >> isReceiverAnalyzed: anObject [
	isReceiverAnalyzed := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> macroExpansionEvaluateInEnvironment: anEnvironment [
	| expandedValue |
	expandedValue := receiver analyzeAndEvaluateInEnvironment: anEnvironment.
	^ expandedValue asAPSGNodeValueWithError: 'Macro expansion expression does not evaluate into an APSG node.' at: self
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> macroExpansionInEnvironment: anEnvironment [
	selector == #__macroExpand ifTrue: [ 
		^ self macroExpansionEvaluateInEnvironment: anEnvironment
	].
	(selector beginsWith: #__macroSend:) ifTrue: [
		^ self macroSendExpansionEvaluateInEnvironment: anEnvironment
	].
	
	^ self shallowCopy
		receiver: (receiver ifNotNil: [receiver macroExpansionInEnvironment: anEnvironment]);
		arguments: (arguments collect: [:arg | arg macroExpansionInEnvironment: anEnvironment]);
		yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> macroSemanticAnalysisInEnvironment: anEnvironment [
	self flag: 'Analyze special macro messages'.
	^ self shallowCopy
		receiver: (receiver ifNotNil: [receiver macroSemanticAnalysisInEnvironment: anEnvironment]);
		arguments: (arguments collect: [:arg | arg macroSemanticAnalysisInEnvironment: anEnvironment]);
		yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> macroSendExpansionEvaluateInEnvironment: anEnvironment [
	| messageSelector |
	messageSelector := arguments first analyzeAndEvaluateInEnvironment: anEnvironment.
	messageSelector type isLiteralSymbol ifFalse: [ 
		self error: 'Macro send expansion selector does not evaluate into a selector.' at: self
	].
	^ self shallowCopy
		selector: messageSelector value;
		receiver: (receiver ifNotNil: [receiver macroExpansionInEnvironment: anEnvironment]);
		arguments: (arguments allButFirst collect: [:arg | arg macroExpansionInEnvironment: anEnvironment]);
		yourself
]

{ #category : #accessing }
SYMLAPSGMessageSend >> metaMethod [
	^ metaMethod
]

{ #category : #accessing }
SYMLAPSGMessageSend >> metaMethod: anObject [
	metaMethod := anObject
]

{ #category : #copying }
SYMLAPSGMessageSend >> postCopy [
	receiver := receiver copy.
	arguments := arguments collect: #copy.
]

{ #category : #printing }
SYMLAPSGMessageSend >> printOn: aStream [
	aStream nextPutAll: 'send '; print: selector
]

{ #category : #accessing }
SYMLAPSGMessageSend >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLAPSGMessageSend >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SYMLAPSGMessageSend >> selector [
	^ selector
]

{ #category : #accessing }
SYMLAPSGMessageSend >> selector: anObject [
	selector := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageSend >> semanticAnalysisInEnvironment: anEnvironment [
	metaMethod ifNotNil: [ ^ self ].
	^ anEnvironment semanticAnalyzeMessage: self at: self
]

{ #category : #accessing }
SYMLAPSGMessageSend >> valueType [
	^ valueType
]

{ #category : #accessing }
SYMLAPSGMessageSend >> valueType: anObject [
	valueType := anObject
]

{ #category : #testing }
SYMLAPSGMessageSend >> withAnalyzedReceiverAndArgumentsInEnvironment: anEnvironment [
	(self isReceiverAnalyzed and: [ self hasAnalyzedArguments ]) ifTrue: [ ^ self ].
	^ self copy
		receiver: (isReceiverAnalyzed
			ifTrue: [ receiver ]
			ifFalse: [ receiver ifNotNil: [receiver semanticAnalysisInEnvironment: anEnvironment] ]);
		isReceiverAnalyzed: true;
		arguments: (argumentsAreAnalyzed
			ifTrue: [ arguments ]
			ifFalse: [ arguments collect: [ :arg | arg semanticAnalysisInEnvironment: anEnvironment]]);
		argumentsAreAnalyzed: true;
		yourself
]

{ #category : #annotations }
SYMLAPSGMessageSend >> withMetaMethod: aMetaMethod [
	^ self copy metaMethod: aMetaMethod; yourself
]
