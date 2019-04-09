"
I am a visitor for the AST nodes of the MoebiusBand AST nodes.
"
Class {
	#name : #MbndAstVisitor,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVisitor >> visitBreakStatementNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitCasesOfCaseNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitCasesOfDefaultCaseNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitCasesOfNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitContinueStatementNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitDoWhileLoopNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitExpandedMessageSendNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFunctionCallNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitIdentifierReferenceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitIfConditionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitLexicalScopeNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitLiteralValueNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitLocalVariableDefinition: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMessageChainMessageNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMessageChainNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMetaBuilderInstanceNode: node [
	self subclassResponsibility
]

{ #category : #'visitor utilties' }
MbndAstVisitor >> visitNode: node [
	^ node accept: self
]

{ #category : #'visitor utilties' }
MbndAstVisitor >> visitNodes: nodes [
	nodes do: [ :node | node accept: self ]
]

{ #category : #'visitor utilties' }
MbndAstVisitor >> visitNodesAndCollect: nodes [
	^ nodes collect: [ :node | node accept: self ]
]

{ #category : #visiting }
MbndAstVisitor >> visitPragmaNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitQuasiQuoteNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitQuasiUnquoteNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitQuoteNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitReturnStatementNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitSequenceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitSpliceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitUnexpandedMessageSendNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitWhileLoopNode: node [
	self subclassResponsibility
]
