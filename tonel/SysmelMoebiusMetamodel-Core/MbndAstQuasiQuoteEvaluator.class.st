Class {
	#name : #MbndAstQuasiQuoteEvaluator,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'unquoteEvaluator'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Evaluation'
}

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> unquoteEvaluator [
	^ unquoteEvaluator
]

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> unquoteEvaluator: anObject [
	unquoteEvaluator := anObject
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
	| basicExpansion blockNode bodyNode |
	basicExpansion := super visitMacroExpansionInlineBlockNode: node.
	blockNode := basicExpansion blockNode.
	bodyNode := blockNode.
	blockNode isBlockClosureNode ifTrue: [
		blockNode arguments size < node argumentNodes size ifTrue: [ 
			self error: 'Insufficient number of arguments for inline block expansion. Only {1} arguments are provided.' format: { node argumentNodes size asString } at: node
		].
	
		"This is a block that we must expand."
		bodyNode := MbndAstImmediateBlockClosureActivationNode new
			position: node;
			blockNode: blockNode;
			arguments: (basicExpansion argumentNodes first: blockNode arguments size);
			yourself
	].

	"The node is not a block, ignore the arguments."	
	basicExpansion ensureNode ifNotNil: [:ensureNode |
		^ MbndAstCleanUpScopeNode new 
			position: node;
			expression: bodyNode;
			explicitCleanUpActions: { ensureNode lexicallyScoped };
			yourself
	] ifNil: [
		^ bodyNode
	]
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
MbndAstQuasiQuoteEvaluator >> visitQuasiUnquoteNode: node [
	| result |
	result := unquoteEvaluator visitNode: node expression.
	self assert: result type isASTNodeType.
	^ result value
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
