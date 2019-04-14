Class {
	#name : #MbndBlockClosureMacro,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'block'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #accessing }
MbndBlockClosureMacro >> block [
	^ block
]

{ #category : #accessing }
MbndBlockClosureMacro >> block: anObject [
	block := anObject
]

{ #category : #accessing }
MbndBlockClosureMacro >> expandMessageNode: node with: analyzer [
	| result |
	result := block cull: node cull: analyzer astBuilder cull: analyzer.
	self assert: result isMbndAstNode.
	block numArgs >= 3 ifFalse: [
		^ analyzer visitNode: result
	].
	^ result
]
