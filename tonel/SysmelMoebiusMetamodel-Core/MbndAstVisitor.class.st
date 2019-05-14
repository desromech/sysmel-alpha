"
I am a visitor for the AST nodes of the MoebiusBand AST nodes.
"
Class {
	#name : #MbndAstVisitor,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVisitor >> visitArgumentDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitArrayElementReferenceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitAssignmentNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitBitCastNode: node [
	self subclassResponsibility
]

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
MbndAstVisitor >> visitClassDeclarationNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitClassDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitCompileTimeConstantDefinitionNode: node [
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
MbndAstVisitor >> visitExplicitCastNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFieldDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFloatingPointSizeCastNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFloatingPointToIntegerCastNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFunctionCallNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFunctionDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitFunctionPrototypeNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitGCClassDeclarationNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitGCClassDefinitionNode: node [
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
MbndAstVisitor >> visitImplicitCastNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitIntegerToFloatingPointCastNode: node [
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
MbndAstVisitor >> visitLocalVariableDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMacroMessageDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMacroMessagePrototypeNode: node [
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
MbndAstVisitor >> visitMessageDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMessagePrototypeNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMetaBuilderInstanceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitMethodReferenceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitNamespaceDefinitionNode: node [
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
	^ nodes collect: [ :node | self visitNode: node ]
]

{ #category : #visiting }
MbndAstVisitor >> visitPointerElementReferenceNode: node [
	self subclassResponsibility
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
MbndAstVisitor >> visitReferenceLoadNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitReinterpretCastNode: node [
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
MbndAstVisitor >> visitSignExtensionCastNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitSpliceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitStructureDeclarationNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitStructureDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitTruncateCastNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitTupleNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitUnexpandedMessageSendNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitUnionDeclarationNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitUnionDefinitionNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitVariableReferenceNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitWhileLoopNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAstVisitor >> visitZeroExtensionCastNode: node [
	self subclassResponsibility
]
