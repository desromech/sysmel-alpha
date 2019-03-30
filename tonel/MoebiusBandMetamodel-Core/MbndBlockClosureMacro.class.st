Class {
	#name : #MbndBlockClosureMacro,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'block'
	],
	#category : #'MoebiusBandMetamodel-Core-Macro'
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
	result := block cull: node cull: (MbndAstBuilder new module: analyzer module) cull: analyzer.
	self assert: result isMbndAstNode.
	^ result
]
