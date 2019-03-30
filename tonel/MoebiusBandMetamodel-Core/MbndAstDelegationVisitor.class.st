"
I am an AST visitor that delegates most of its node visits into another visitor. I can be used for composing visitors.
"
Class {
	#name : #MbndAstDelegationVisitor,
	#superclass : #MbndAstVisitor,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #delegate }
MbndAstDelegationVisitor >> delegateNodeVisit: aNode [
	self subclassResponsibility
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
MbndAstDelegationVisitor >> visitFunctionCallNode: node [
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
MbndAstDelegationVisitor >> visitLexicalScopeNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitLiteralValueNode: node [
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
MbndAstDelegationVisitor >> visitUnexpandedMessageSendNode: node [
	^ self delegateNodeVisit: node
]

{ #category : #visiting }
MbndAstDelegationVisitor >> visitWhileLoopNode: node [
	^ self delegateNodeVisit: node
]
