"
I am a visitor that constructs a transformed AST without modifying the original AST.
"
Class {
	#name : #MbndAstTransformVisitor,
	#superclass : #MbndAstVisitor,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTransformVisitor >> visitBreakStatementNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCasesOfCaseNode: node [
	^ node copy
		pattern: (self visitNode: node pattern);
		action: (self visitNode: node action);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCasesOfDefaultCaseNode: node [
	^ node copy
		action: (self visitNode: node action);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitCasesOfNode: node [
	^ node copy
		cases: (self visitAndCollectNodes: node cases);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitContinueStatementNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitDoWhileLoopNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		action: (self visitNode: node action);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitExpandedMessageSendNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		selector: (self visitNode: node selector);
		arguments: (self visitAndCollectNodes: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionCallNode: node [
	^ node copy
		function: (self visitNode: node function);
		arguments: (self visitAndCollectNodes: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIdentifierReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitIfConditionNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		trueValue:  (self visitNode: node trueValue);
		falseValue: (self visitNode: node falseValue);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitLexicalScopeNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitLiteralValueNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageChainMessageNode: node [
	^ node copy
		selector: (self visitNode: node selector);
		arguments: (self visitAndCollectNodes: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageChainNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		messages: (self visitAndCollectNodes: node messages);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPragmaNode: node [
	^ node copy
		selector: (node selector);
		arguments: (self visitAndCollectNodes: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitQuasiQuoteNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitQuasiUnquoteNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitQuoteNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSequenceNode: node [
	^ node copy
		pragmas: (self visitAndCollectNodes: node pragmas);
		elements: (self visitAndCollectNodes: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSpliceNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitUnexpandedMessageSendNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		selector: (self visitNode: node selector);
		arguments: (self visitAndCollectNodes: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitWhileLoopNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		action: (self visitNode: node action);
		yourself
]
