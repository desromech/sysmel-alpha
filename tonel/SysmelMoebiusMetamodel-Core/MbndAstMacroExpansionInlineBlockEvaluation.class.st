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

{ #category : #serialization }
MbndAstMacroExpansionInlineBlockEvaluation >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#blockNode . blockNode encodeGraphForMessagePackWith: graphEncoder.
		#argumentNodes . argumentNodes encodeGraphForMessagePackWith: graphEncoder.
		#ensureNode . ensureNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
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

{ #category : #serialization }
MbndAstMacroExpansionInlineBlockEvaluation >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	blockNode := encodedFields at: #blockNode.
	argumentNodes := encodedFields at: #argumentNodes.
	ensureNode := encodedFields at: #ensureNode.
]
