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
		'hasIncompleteSemanticAnalysis'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

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
	^ metaMethod generateMessage: self ssaCodeWith: builder
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

{ #category : #annotations }
SYMLAPSGMessageSend >> withMetaMethod: aMetaMethod [
	^ self copy metaMethod: aMetaMethod; yourself
]
