Class {
	#name : #MbndAstImmediateBlockClosureActivationNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'blockNode',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstImmediateBlockClosureActivationNode >> accept: visitor [
	^ visitor visitImmediateBlockClosureActivationNode: self
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> blockNode [
	^ blockNode
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> blockNode: anObject [
	blockNode := anObject
]

{ #category : #testing }
MbndAstImmediateBlockClosureActivationNode >> isImmediateBlockClosureActivationNode [
	^ true
]
