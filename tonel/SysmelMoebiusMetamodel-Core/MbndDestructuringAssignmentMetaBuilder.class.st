Class {
	#name : #MbndDestructuringAssignmentMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#instVars : [
		'patternNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #definition }
MbndDestructuringAssignmentMetaBuilder >> assignValue: value [
	^ currentAnalyzer visitNode: (MbndAstDestructuringAssignmentNode new
		position: position;
		pattern: patternNode;
		value: value;
		yourself)
]

{ #category : #'semantic analysis' }
MbndDestructuringAssignmentMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	self error: 'Destructuring assignment requires an inital value.' at: node
]

{ #category : #accessing }
MbndDestructuringAssignmentMetaBuilder >> patternNode [
	^ patternNode
]

{ #category : #accessing }
MbndDestructuringAssignmentMetaBuilder >> patternNode: anObject [
	patternNode := anObject
]
