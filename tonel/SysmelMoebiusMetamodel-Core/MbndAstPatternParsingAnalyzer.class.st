Class {
	#name : #MbndAstPatternParsingAnalyzer,
	#superclass : #MbndAstDelegationVisitor,
	#instVars : [
		'semanticAnalyzer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #delegate }
MbndAstPatternParsingAnalyzer >> delegateNodeVisit: node [
	^ node
]

{ #category : #delegate }
MbndAstPatternParsingAnalyzer >> parseNode: node [
	| expandedNode matchedNode astBuilder |
	"Try to match the node."
	matchedNode := self visitNode: node.
	matchedNode isPatternMatchingPatternNode ifTrue: [ ^ matchedNode ].

	"Try to expand the macros, and match the node again.."
	expandedNode := semanticAnalyzer visitNodeForMacroExpansion: node.
	expandedNode isPatternMatchingPatternNode ifTrue: [ ^ expandedNode ].

	matchedNode := self visitNode: expandedNode.
	matchedNode isPatternMatchingPatternNode ifTrue: [ ^ matchedNode ].

	"The node is not matched, so delegate the parsing job to its value type."	
	astBuilder := semanticAnalyzer astBuilder.
	^ semanticAnalyzer visitNode: ((astBuilder unexpandedSend:
		((astBuilder literalSymbol: #asPatternMatchingPattern)
			position: matchedNode) to: matchedNode withArguments: #())
			position: matchedNode)

]

{ #category : #accessing }
MbndAstPatternParsingAnalyzer >> semanticAnalyzer [
	^ semanticAnalyzer
]

{ #category : #accessing }
MbndAstPatternParsingAnalyzer >> semanticAnalyzer: anObject [
	semanticAnalyzer := anObject
]

{ #category : #visiting }
MbndAstPatternParsingAnalyzer >> visitIdentifierReferenceNode: node [
	node symbol isMbndAnonymousSymbol ifTrue: [ 
		^ MbndAstPatternMatchingAnyPatternNode new
			position: node;
			yourself
	].

	^ node
]

{ #category : #visiting }
MbndAstPatternParsingAnalyzer >> visitLocalVariableDefinitionNode: node [
	| result |
	
	(node name isMbndAnonymousSymbol and: [ node initialValue isNil ]) ifTrue: [ 
		^ MbndAstPatternMatchingAnyPatternNode new
			position: node;
			yourself
	].

	result := MbndAstPatternMatchingBindingPatternNode new
		position: node;
		name: node name;
		requiredType: node valueType;
		yourself.
	node initialValue ifNotNil: [ :valuePatternNode |
		result valuePattern: (self parseNode: valuePatternNode)
	].

	^ result
]

{ #category : #visiting }
MbndAstPatternParsingAnalyzer >> visitTupleNode: node [
	^ MbndAstPatternMatchingTuplePatternNode new
		position: node;
		expectedElements: (node elements collect: [ :each | self parseNode: each ]);
		yourself
]
