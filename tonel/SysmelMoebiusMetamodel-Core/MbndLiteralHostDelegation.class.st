"
I am a macro implementation that is used for implementing compile time evaluation of literal expressions.
"
Class {
	#name : #MbndLiteralHostDelegation,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'hostSelector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndLiteralHostDelegation class >> messagePackTypeName [
	^ #LiteralHostDelegation
]

{ #category : #serialization }
MbndLiteralHostDelegation >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#hostSelector . hostSelector.
	}
]

{ #category : #'as yet unclassified' }
MbndLiteralHostDelegation >> expandMessageNode: node with: analyzer [
	| receiver arguments result |
	self assert: node receiver isLiteralValueNode.

	"Make sure the arguments are also a literal."
	node arguments: (analyzer analyzeNodesIfNeeded: node arguments).
	
	"If one of the arguments is not a literal node, then fallback towards a normal message send."
	(node arguments allSatisfy: [:each | each isLiteralValueNode]) ifFalse: [
		^ analyzer visitNode: node asExpandedMessageSend
	].

	"Unwrap the literal values."
	receiver := node receiver value.
	arguments := node arguments collect: [:each | each value].
	
	"Compute the result."
	MbndHostMessageEvaluationScope withValue: analyzer scope do: [
		result := receiver perform: hostSelector withArguments: arguments.
	].

	^ (result asMoebiusLiteralValueNodeWithTarget: analyzer compilationTarget)
		position: node;
		yourself
]

{ #category : #accessing }
MbndLiteralHostDelegation >> hostSelector [
	^ hostSelector
]

{ #category : #accessing }
MbndLiteralHostDelegation >> hostSelector: anObject [
	hostSelector := anObject
]

{ #category : #serialization }
MbndLiteralHostDelegation >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	hostSelector := encodedFields at: #hostSelector.
]
