Class {
	#name : #MbndAstWhileLoopNode,
	#superclass : #MbndAstStatementNode,
	#instVars : [
		'condition',
		'action',
		'continueAction'
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

{ #category : #accessing }
MbndAstWhileLoopNode >> continueAction [
	^ continueAction
]

{ #category : #accessing }
MbndAstWhileLoopNode >> continueAction: anObject [
	continueAction := anObject
]

{ #category : #testing }
MbndAstWhileLoopNode >> isWhileLoopNode [
	^ true
]
