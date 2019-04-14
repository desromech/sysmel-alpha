Class {
	#name : #MbndAstWhileLoopNode,
	#superclass : #MbndAstStatementNode,
	#instVars : [
		'condition',
		'action'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstWhileLoopNode >> accept: aVisitor [
	^ aVisitor visitWhileLoopNode: self
]

{ #category : #accessing }
MbndAstWhileLoopNode >> action [
	^ action
]

{ #category : #accessing }
MbndAstWhileLoopNode >> action: anObject [
	action := anObject
]

{ #category : #accessing }
MbndAstWhileLoopNode >> condition [
	^ condition
]

{ #category : #accessing }
MbndAstWhileLoopNode >> condition: anObject [
	condition := anObject
]

{ #category : #testing }
MbndAstWhileLoopNode >> isWhileLoopNode [
	^ true
]
