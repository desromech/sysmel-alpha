Class {
	#name : #MbndAstQuasiQuoteSemanticAnalyzer,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'unquoteAnalyzer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #accessing }
MbndAstQuasiQuoteSemanticAnalyzer >> compilationTarget [
	^ unquoteAnalyzer compilationTarget
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> processMacroInlineBlockNode: node withSelector: selector [
	| result |
	result := MbndAstMacroExpansionInlineBlockEvaluation new
		position: node;
		blockNode: node receiver;
		argumentNodes: node arguments;
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

	self halt
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
			self halt
		]
	].

	^ super visitUnexpandedMessageSendNode: node
]

{ #category : #visiting }
MbndAstQuasiQuoteSemanticAnalyzer >> visitQuasiUnquoteNode: node [
	^ node copy
		expression: (unquoteAnalyzer addImplicitCastFor: (unquoteAnalyzer visitNode: node expression) to: self compilationTarget astNodeType);
		yourself.
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
