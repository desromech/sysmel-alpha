Class {
	#name : #MbndAstQuasiQuoteSemanticAnalyzer,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'unquoteAnalyzer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #accessing }
MbndAstQuasiQuoteSemanticAnalyzer >> compilationEnvironment [
	^ unquoteAnalyzer compilationEnvironment
]

{ #category : #accessing }
MbndAstQuasiQuoteSemanticAnalyzer >> compilationTarget [
	^ unquoteAnalyzer compilationTarget
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> processMacroInlineBlockNode: node withSelector: selector [
	| result |
	result := MbndAstMacroExpansionInlineBlockEvaluation new
		position: node;
		blockNode: (self visitNode: node receiver);
		argumentNodes: (self visitNodesAndCollect: node arguments);
		yourself.
		
	((selector endsWith: #':ensure:') or: [selector endsWith: #'Ensure:']) ifTrue: [ 
		result
			argumentNodes: node arguments allButLast;
			ensureNode: node arguments last
	].
	^ self visitNode: result
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> processMacroMessageSendNode: node withSelector: selector [
	(selector beginsWith: #__macroInlineBlock) ifTrue: [
		^ self processMacroInlineBlockNode: node withSelector: selector
	].

	selector = #__macroSend:with: ifTrue: [
		^ self processMacroSendMessageWithArguments: node
	].

	self halt
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> processMacroSendMessageWithArguments: node [
	^ self visitNode: (MbndAstMacroSendMessageWithArgumentsNode new
		position: node;
		receiver: node receiver;
		selector: node arguments first;
		arguments: node arguments allButFirst;
		yourself)

]

{ #category : #accessing }
MbndAstQuasiQuoteSemanticAnalyzer >> unquoteAnalyzer [
	^ unquoteAnalyzer
]

{ #category : #accessing }
MbndAstQuasiQuoteSemanticAnalyzer >> unquoteAnalyzer: anObject [
	unquoteAnalyzer := anObject
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> visitExpandedMessageSendNode: node [
	| selector |
	node selector isLiteralSymbolValueNode ifTrue: [ 
		selector := node selector value.
		(selector beginsWith: #__macro) ifTrue: [
			^ self processMacroMessageSendNode: node withSelector: selector
		]
	].

	^ super visitExpandedMessageSendNode: node
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> visitQuasiQuoteNode: node [
	^ node
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> visitQuasiUnquoteNode: node [
	^ node copy
		expression: (unquoteAnalyzer addImplicitCastFor: (unquoteAnalyzer visitNode: node expression) to: self compilationTarget astNodeType);
		yourself.
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> visitQuoteNode: node [
	^ node
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> visitUnexpandedMessageSendNode: node [
	| selector |
	node selector isLiteralSymbolValueNode ifTrue: [ 
		selector := node selector value.
		(selector beginsWith: #__macro) ifTrue: [
			^ self processMacroMessageSendNode: node withSelector: selector
		]
	].

	^ super visitUnexpandedMessageSendNode: node
]
