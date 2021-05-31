Class {
	#name : #MbndAstQuasiQuoteEvaluator,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'unquoteEvaluator',
		'validSourcePosition'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Evaluation'
}

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> emitBlockClosureNode: bodyNode activationWith: argumentNodes [
	(bodyNode isExceptionScopeNode or: [ bodyNode isSequenceNode ]) ifTrue: [ ^ bodyNode ].
	self halt
]

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> unquoteEvaluator [
	^ unquoteEvaluator
]

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> unquoteEvaluator: anObject [
	unquoteEvaluator := anObject
]

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> validSourcePosition [
	^ validSourcePosition ifNil: [validSourcePosition := unquoteEvaluator scope validSourcePosition]
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitExpandedMessageSendNode: node [
	| result |
	result := super visitExpandedMessageSendNode: node.
	(node selector isQuasiUnquoteNode and: [ result selector isGeneratedIdentifierNode ]) ifTrue: [ 
		result := result copy
			position: node;
			selector: (result selector asLiteralSymbolNodeFor: unquoteEvaluator module compilationTarget);
			yourself
	].
	
	^ result
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitMacroExpansionInlineBlockNode: node [
	| basicExpansion blockNode activationAttempt |
	basicExpansion := super visitMacroExpansionInlineBlockNode: node.
	blockNode := basicExpansion blockNode.
	blockNode isBlockClosureNode ifTrue: [
		node argumentNodes size < blockNode arguments size ifTrue: [ 
			self error: 'Insufficient number of arguments for inline block expansion. Only {1} arguments are provided.' format: { node argumentNodes size asString } at: node
		].
	
		"This is a block that we must expand."
		activationAttempt := MbndAstImmediateBlockClosureActivationNode new
			position: node;
			blockNode: blockNode;
			arguments: (basicExpansion argumentNodes first: blockNode arguments size);
			yourself
	].

	"Allow applying unary selectors."
	(activationAttempt isNil and: [
	node argumentNodes size = 1 and: [
	blockNode isLiteralSymbolValueNode]]) ifTrue: [
		blockNode value numArgs = 0 ifTrue: [
			activationAttempt := MbndAstUnexpandedMessageSendNode new
				position: node;
				selector: blockNode;
				receiver: (self visitNode: node argumentNodes first);
				arguments: #()
		].
	].

	"The node is not a block, ignore the arguments."
	activationAttempt ifNil:[
		activationAttempt := MbndAstBlockClosureActivationAttemptNode new
			position: basicExpansion;
			blockNode: blockNode;
			arguments: basicExpansion argumentNodes;
			yourself.
	].

	basicExpansion ensureNode ifNotNil: [:ensureNode |
		^ MbndAstExceptionScopeNode new 
			position: node;
			expression: activationAttempt;
			explicitCleanUpActions: { ensureNode lexicallyScoped };
			yourself
	] ifNil: [
		^ activationAttempt
	]
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitMacroSendMessageNode: node [
	| receiver messageNode |
	receiver := self visitNode: node receiver.
	messageNode := self visitNode: node message.
	messageNode isMessageChainMessageNode ifFalse: [ 
		self error: 'Expected a message chain message node describing a message to send during a macro expansion.' at: node
	].

	^ MbndAstUnexpandedMessageSendNode new
		position: messageNode position;
		receiver: receiver;
		selector: messageNode selector;
		arguments: messageNode arguments;
		yourself
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitMacroSendMessageWithArgumentsNode: node [
	| basicExpansion |
	basicExpansion := super visitMacroSendMessageWithArgumentsNode: node.
	^ MbndAstUnexpandedMessageSendNode new
		position: node;
		receiver: basicExpansion receiver;
		selector: basicExpansion selector;
		arguments: basicExpansion arguments;
		yourself
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitNode: node [
	| result |
	result := super visitNode: node.
	result hasEmptySourcePosition ifTrue: [
		result := result copyWithConcreteSourcePosition: self validSourcePosition
	].

	^ result
]

{ #category : #'visitor utilties' }
MbndAstQuasiQuoteEvaluator >> visitNodesAndCollect: nodes [
	| result |
	(nodes anySatisfy: [ :each | each isSpliceNode ]) ifFalse: [ ^ super visitNodesAndCollect: nodes ].
	
	result := OrderedCollection new.
	nodes do: [ :each |
		each isSpliceNode ifTrue: [
			result addAll: (self evaluateSpliceNode: each)
		] ifFalse: [
			result add: (self visitNode: each )
		].
	].

	^ nodes asArray
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitQuasiQuoteNode: node [
	^ node
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitQuasiUnquoteNode: node [
	| result |
	result := unquoteEvaluator visitNode: node expression.
	self assert: result type isASTNodeType.
	^ result value
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitQuoteNode: node [
	^ node
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitSpliceNode: node [
	self error: 'Splice evaluation is not allowed in this context.' at: node
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitUnexpandedMessageSendNode: node [
	| result |
	result := super visitUnexpandedMessageSendNode: node.
	(node selector isQuasiUnquoteNode and: [ result selector isGeneratedIdentifierNode ]) ifTrue: [ 
		result := result copy
			position: node;
			selector: (result selector asLiteralSymbolNodeFor: unquoteEvaluator module compilationTarget);
			yourself
	].
	
	^ result
]
