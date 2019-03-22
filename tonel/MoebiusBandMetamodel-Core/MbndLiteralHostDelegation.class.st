Class {
	#name : #MbndLiteralHostDelegation,
	#superclass : #MbndAbstractMacro,
	#category : #'MoebiusBandMetamodel-Core-Macro'
}

{ #category : #'as yet unclassified' }
MbndLiteralHostDelegation >> expandMessageNode: node with: analyzer [
	| receiver arguments result resultType |
	self assert: node receiver isLiteralValueNode.
	
	"Make sure the arguments are also a literal."
	node arguments: (analyzer analyzeNodesIfNeeded: node arguments).
	
	"If one of the arguments is not a literal node, then fallback towards a normal message send."
	(node arguments allSatisfy: #isLiteralValueNode) ifFalse: [
		^ analyzer visitNode: node asExpandedMessageSend
	].

	"Unwrap the literal values."
	receiver := node receiver value.
	arguments := node arguments collect: #value.
	
	"Compute the result."
	result := receiver perform: node selector value withArguments: arguments.
	resultType := result mbndLiteralTypeWithTarget: analyzer compilationTarget.
	^ MbndAstLiteralValueNode new
		position: node;
		value: result;
		type: resultType;
		yourself
]
