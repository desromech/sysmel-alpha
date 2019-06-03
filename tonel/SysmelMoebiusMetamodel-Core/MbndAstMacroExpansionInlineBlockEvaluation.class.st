Class {
	#name : #MbndAstMacroExpansionInlineBlockEvaluation,
	#superclass : #MbndAstNode,
	#instVars : [
		'blockNode',
		'argumentNodes',
		'ensureNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstMacroExpansionInlineBlockEvaluation >> accept: aVisitor [
	^ aVisitor visitMacroExpansionInlineBlockNode: self
]

{ #category : #accessing }
MbndAstMacroExpansionInlineBlockEvaluation >> argumentNodes [
	^ argumentNodes
]

{ #category : #accessing }
MbndAstMacroExpansionInlineBlockEvaluation >> argumentNodes: anObject [
	argumentNodes := anObject
]

{ #category : #accessing }
MbndAstMacroExpansionInlineBlockEvaluation >> blockNode [
	^ blockNode
]

{ #category : #accessing }
MbndAstMacroExpansionInlineBlockEvaluation >> blockNode: anObject [
	blockNode := anObject
]

{ #category : #accessing }
MbndAstMacroExpansionInlineBlockEvaluation >> ensureNode [
	^ ensureNode
]

{ #category : #accessing }
MbndAstMacroExpansionInlineBlockEvaluation >> ensureNode: anObject [
	ensureNode := anObject
]

{ #category : #'as yet unclassified' }
MbndAstMacroExpansionInlineBlockEvaluation >> isMacroExpansionInlineBlockNode [
	^ true
]
