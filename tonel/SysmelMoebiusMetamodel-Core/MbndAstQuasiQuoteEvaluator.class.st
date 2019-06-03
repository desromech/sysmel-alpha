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
MbndAstQuasiQuoteEvaluator >> visitMacroExpansionInlineBlockNode: node [
	| basicExpansion blockNode |
	basicExpansion := super visitMacroExpansionInlineBlockNode: node.
	blockNode := basicExpansion blockNode.
	blockNode isBlockClosureNode ifTrue: [
		"This is a block that we must expand."
		self halt
	].

	"The node is not a block, ignore the arguments."	
	basicExpansion ensureNode ifNotNil: [:ensureNode |
		^ MbndAstCleanUpScopeNode new 
			position: node;
			expression: blockNode;
			cleanUpActions: { ensureNode lexicallyScoped };
			yourself
	] ifNil: [
		^ blockNode
	]
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitQuasiUnquoteNode: node [
	| result |
	result := unquoteEvaluator visitNode: node expression.
	self assert: result type isASTNodeType.
	^ result value
]
