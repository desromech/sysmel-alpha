"
I am an AST visitor that delegates most of its node visits into another visitor. I can be used for composing visitors.
"
Class {
	#name : #MbndAstDelegationVisitor,
	#superclass : #MbndAstVisitor,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #delegate }
MbndAstDelegationVisitor >> delegateNodeVisit: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArgumentDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitArrayElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitAssignmentNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitBreakStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCasesOfCaseNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCasesOfDefaultCaseNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCasesOfNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitCompileTimeConstantDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitContinueStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitDoWhileLoopNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExpandedMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitExplicitCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFunctionCallNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFunctionDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitFunctionPrototypeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIdentifierReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitIfConditionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitImplicitCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLexicalScopeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLiteralValueNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLocalVariableDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMacroMessageDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMacroMessagePrototypeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessageChainMessageNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessageChainNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessageDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMessagePrototypeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMetaBuilderInstanceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitMethodReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitNamespaceDefinitionNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPointerElementReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitPragmaNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitQuasiQuoteNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitQuasiUnquoteNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitQuoteNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReferenceLoadNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReinterpretCastNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitReturnStatementNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSequenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitSpliceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitTupleNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitUnexpandedMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitVariableReferenceNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitWhileLoopNode: node [
	^ self delegateNodeVisit: node
]
