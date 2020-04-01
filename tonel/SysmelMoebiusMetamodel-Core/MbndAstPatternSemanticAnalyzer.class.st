Class {
	#name : #MbndAstPatternSemanticAnalyzer,
	#superclass : #MbndAstDelegationVisitor,
	#instVars : [
		'patternValueType',
		'semanticAnalyzer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #delegate }
MbndAstPatternSemanticAnalyzer >> delegateNodeVisit: node [
	
	| analyzedNode |
	(node isMessageChainNode or: [ node isUnexpandedMessageSendNode or: [node isIdentifierReferenceNode ]]) ifTrue: [
		analyzedNode := semanticAnalyzer visitNodeForMacroExpansion: node.
		analyzedNode isPatternMatchingPatternNode ifTrue: [ ^ analyzedNode ].
		^ self visitNode: analyzedNode
	].
	node isSpecificCastNode ifTrue: [ ^ node asSameValuePatternNode ].
	self error: 'Unsupported node type {1} for specifying a pattern.' format: { node class name } at: node
]

{ #category : #accessing }
MbndAstPatternSemanticAnalyzer >> patternValueType [
	^ patternValueType
]

{ #category : #accessing }
MbndAstPatternSemanticAnalyzer >> patternValueType: anObject [
	patternValueType := anObject
]

{ #category : #accessing }
MbndAstPatternSemanticAnalyzer >> semanticAnalyzer [
	^ semanticAnalyzer
]

{ #category : #accessing }
MbndAstPatternSemanticAnalyzer >> semanticAnalyzer: anObject [
	semanticAnalyzer := anObject
]

{ #category : #visiting }
MbndAstPatternSemanticAnalyzer >> visitLiteralValueNode: node [
	node type isLiteralIntervalType ifTrue: [
		| intervalNode |
		intervalNode := node asIntervalPatternNode.	
		^ intervalNode copy
			start: (semanticAnalyzer addImplicitCastFor: intervalNode start to: patternValueType);
			stop: (semanticAnalyzer addImplicitCastFor: intervalNode stop to: patternValueType);
			yourself
	].

	node type ~= patternValueType ifTrue: [
		^ self visitNode: (semanticAnalyzer addImplicitCastFor: node to: patternValueType) 
	].

	^ node asLiteralValuePatternNode
]

{ #category : #visiting }
MbndAstPatternSemanticAnalyzer >> visitLocalVariableDefinitionNode: node [
	| result |
	result := MbndAstPatternMatchingBindingPatternNode new
		position: node;
		name: node name;
		type: patternValueType;
		yourself.
	node initialValue ifNotNil: [ 
		self halt
	].

	semanticAnalyzer createBindingPatternLocalVariable: result.
	^ result
]
