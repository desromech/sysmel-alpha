Class {
	#name : #MbndAstMessageChainMessageNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageChainMessageNode >> accept: aVisitor [
	^ aVisitor visitMessageChainMessageNode: self
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #testing }
MbndAstMessageChainMessageNode >> isMessageChainMessageNode [
	^ true
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> selector: anObject [
	selector := anObject
]
