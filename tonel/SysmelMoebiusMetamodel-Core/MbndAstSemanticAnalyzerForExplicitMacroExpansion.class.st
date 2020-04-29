Class {
	#name : #MbndAstSemanticAnalyzerForExplicitMacroExpansion,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'scope',
		'module',
		'compilationTarget',
		'astBuilder',
		'continueOwner',
		'breakOwner',
		'compilationEnvironment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> analyzeNodeIfNeeded: node [
	"Visit the node only if it does not have a type value."
	^ node type
		ifNil: [ self visitNode: node ]
		ifNotNil: [ node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> analyzeNodesIfNeeded: nodes [
	^ nodes collect: [ :node | self analyzeNodeIfNeeded: node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> analyzeNonConcreteNodeIfNeeded: node [
	"Visit the node only if it does not have a type value."
	^ node type
		ifNil: [ self visitNonConcreteNode: node ]
		ifNotNil: [ node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> asAnalyzer [
	^ self as: MbndAstSemanticAnalyzer
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> astBuilder [
	^ astBuilder ifNil: [ astBuilder := MbndAstBuilder forModule: module ]
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> checkForRestrictedSymbol: symbolName at: node [
	| found |
	found := scope lookupSymbolRecursively: symbolName ifAbsent: [ ^ self ].
	found ifNil: [ ^ self ].
	found isMetaBuilderFactory ifTrue: [ 
		self warning: 'Symbol #{1} bound to metabuild is overriden at this scope.' format: { symbolName asPrettySymbolName } at: node
	].

]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> compilationEnvironment [
	^ compilationEnvironment ifNil: [ compilationEnvironment := module compilationEnvironment ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> compilationTarget [
	^ compilationTarget ifNil: [ compilationTarget := module compilationTarget ]
]

{ #category : #errors }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> error: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: scope;
		signal
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> markCompileTimeEvaluationImpossibility [
	"This is a nop in this context"
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> module [
	^ module
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> scope [
	^ scope
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> scope: anObject [
	scope := anObject
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitExpandedHostMessageSendNode: node [
	"The analysis of this node is performed when is constructed."
	self shouldNotImplement
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitExpandedMessageSendNode: node [
	^ node
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitFunctionCallNode: node [
	| result functionalType |
	result := node copy.
	result arguments isMbndAstNode ifTrue: [
		"Rewrite the node by removing the tuple object."
		result arguments isTupleNode ifTrue: [
			^ self visitNode: (result arguments: result arguments elements)
		] ifFalse: [
			^ self visitNode: (result arguments: (self visitSplicingTupleNode: result arguments))
		]
	].

	result
		function: (self analyzeNodeIfNeeded: node function);
		arguments: (self analyzeNodesIfNeeded: result arguments).
		
	functionalType := result function type withoutReferences.
	self assert: functionalType isFunctionalType.
	^ functionalType analyzeFunctionCallNode: result with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitIdentifierReferenceNode: node [
	| binding |
	binding := scope lookupSymbolRecursively: node symbol ifAbsent: [
		self error: 'Failed to find binding for {1}.' format: { node symbol asPrettySymbolName } at: node
	].

	^ binding analyzeReferenceNode: node with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitMessageChainNode: node [
	| receiverVariable receiverVariableReference messages unconvertedMessages analyzedReceiver convertedMetaMessages |
	node messages ifEmpty: [
		^ self analyzeNodeIfNeeded: node receiver
	].

	node messages size = 1 ifTrue: [
		^ self analyzeNodeIfNeeded: (node messages first asUnexpandedMessageSend
			receiver: node receiver;
			yourself)
	].

	unconvertedMessages := node messages.
	
	analyzedReceiver := self analyzeNonConcreteNodeIfNeeded: node receiver.
	
	convertedMetaMessages := OrderedCollection new.
	[analyzedReceiver isNonConcreteNode and: [unconvertedMessages isNotEmpty]] whileTrue: [ 
		| message analyzedMessage |
		message := unconvertedMessages first asUnexpandedMessageSend receiver: analyzedReceiver.
		unconvertedMessages := unconvertedMessages allButFirst.
		analyzedMessage := self visitNonConcreteNode: message.
		analyzedMessage isNonConcreteNode ifFalse: [ 
			convertedMetaMessages add: analyzedMessage.
		].
	].

	(convertedMetaMessages isEmpty and: [ unconvertedMessages isEmpty ]) ifTrue: [ 
		^ analyzedReceiver
	].

	self assert: (scope lookupSymbol: node) isNil.
	receiverVariable := MbndAstLocalVariableDefinitionNode new
		tempRef;
		position: node;
		name: node;
		initialValue: analyzedReceiver;
		yourself.
	receiverVariableReference := MbndAstIdentifierReferenceNode new
		position: node;
		symbol: node;
		yourself.
		
	messages := unconvertedMessages collect: [ :message |
		message asUnexpandedMessageSend
			receiver: receiverVariableReference; yourself
	].

	^ self visitNode: (MbndAstSequenceNode new
		position: node;
		elements: { receiverVariable } , convertedMetaMessages asArray, messages;
		yourself)
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitNode: node [
	^ (node accept: self) concretizeNodeWithAnalyzer: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitNodeForIdentifierMacroExpansion: node [
	self class == MbndAstSemanticAnalyzerForIdentifierValueExpansion ifTrue: [ ^ self visitNode: node ].
	^ (self as: MbndAstSemanticAnalyzerForIdentifierValueExpansion) visitNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitNodeForMacroExpansion: node [
	self class == MbndAstSemanticAnalyzerForExplicitMacroExpansion ifTrue: [ ^ self visitNode: node ].
	^ (self as: MbndAstSemanticAnalyzerForExplicitMacroExpansion) visitNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitNonConcreteNode: node [
	^ node accept: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitPatternMatchingSetPatternNode: node [
	| elements |
	elements := self analyzeNodesIfNeeded: node elements.
	^ node copy
		elements: elements;
		type: self compilationTarget patternMatchingPatternType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitTupleNode: node [
	| result |
	result := super visitTupleNode: node.
	result type: (self compilationTarget tuple: (result elements collect: [:each | each type])).
	result type hasTrivialFinalization ifFalse: [
		self addNodeWithImplicitFinalization: result
	].

	result type isMemoryReturnedType ifTrue: [ result type: result type tempRef].
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> visitUnexpandedMessageSendNode: node [
	| result selector macroMethod ownerEntity |
	result := node copy
		receiver: (node receiver ifNotNil: [self analyzeNonConcreteNodeIfNeeded: node receiver]);
		selector: (self analyzeNodeIfNeeded: node selector);
		yourself.

	result receiver ifNotNil: [
		^ result receiver type analyzeUnexpandedMessageSendNode: result with: self
	].

	result selector isLiteralSymbolValueNode ifFalse: [
		^ self error: 'Invalid message send without receiver. The selector must be a constant.' at: node
	].

	selector := result selector value.
	macroMethod := scope lookupMacroSelector: selector.
	
	"HACK: Lookup the macro on the meta type. This should be fixed by bounding self into the receiver."
	macroMethod ifNil: [
		ownerEntity := scope lookupProgramEntityForNewDefinitions.
		ownerEntity isMbndType ifTrue: [ 
			macroMethod := ownerEntity type lookupMacroSelector: selector.
			macroMethod ifNotNil: [
				result receiver: (ownerEntity type asLiteralValueNode position: node)
			].
		].
	].

	macroMethod ifNil: [
		^ self visitNode: result asExpandedMessageSend
	].

	"Apply the macro method."
	^ macroMethod expandMessageNode: result with: self
]

{ #category : #accessing }
MbndAstSemanticAnalyzerForExplicitMacroExpansion >> withScope: newAnalysisScope do: aBlock [
	| oldAnalysisScope |
	oldAnalysisScope := scope.
	scope := newAnalysisScope.
	
	^ aBlock ensure: [ 
		scope := oldAnalysisScope
	]
]
