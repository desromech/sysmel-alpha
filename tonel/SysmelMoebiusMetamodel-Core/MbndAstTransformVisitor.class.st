"
I am a visitor that constructs a transformed AST without modifying the original AST.
"
Class {
	#name : #MbndAstTransformVisitor,
	#superclass : #MbndAstVisitor,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTransformVisitor >> visitArgumentDefinitionNode: node [
	^ node copy
		valueType: (node valueType ifNotNil: [:vt | self visitNode: vt]);
		initialValue: (node initialValue ifNotNil: [:iv | self visitNode: iv]);
		yourself
]

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
		cases: (self visitNodesAndCollect: node cases);
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
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionCallNode: node [
	^ node copy
		function: (self visitNode: node function);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionDefinitionNode: node [
	^ node copy
		prototype: (self visitNode: node prototype);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitFunctionPrototypeNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		returnType: (node returnType ifNotNil: [self visitNode: node returnType]);
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
MbndAstTransformVisitor >> visitLocalVariableDefinitionNode: node [
	^ node copy
		initialValue: (node initialValue ifNotNil: [:initialValue | self visitNode: initialValue]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageChainMessageNode: node [
	^ node copy
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageChainNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		messages: (self visitNodesAndCollect: node messages);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessageDefinitionNode: node [
	^ node copy
		prototype: (self visitNode: node prototype);
		body: (self visitNode: node body);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMessagePrototypeNode: node [
	^ node copy
		arguments: (self visitNodesAndCollect: node arguments);
		returnType: (node returnType ifNotNil: [self visitNode: node returnType]);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitMetaBuilderInstanceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitPragmaNode: node [
	^ node copy
		selector: (node selector);
		arguments: (self visitNodesAndCollect: node arguments);
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
MbndAstTransformVisitor >> visitReturnStatementNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSequenceNode: node [
	^ node copy
		pragmas: (self visitNodesAndCollect: node pragmas);
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitSpliceNode: node [
	^ node copy
		expression: (self visitNode: node expression);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitTupleNode: node [
	^ node copy
		elements: (self visitNodesAndCollect: node elements);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitUnexpandedMessageSendNode: node [
	^ node copy
		receiver: (self visitNode: node receiver);
		selector: (self visitNode: node selector);
		arguments: (self visitNodesAndCollect: node arguments);
		yourself
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitVariableReferenceNode: node [
	^ node
]

{ #category : #visiting }
MbndAstTransformVisitor >> visitWhileLoopNode: node [
	^ node copy
		condition: (self visitNode: node condition);
		action: (self visitNode: node action);
		yourself
]