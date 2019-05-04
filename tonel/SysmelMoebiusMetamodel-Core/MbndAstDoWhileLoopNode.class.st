Class {
	#name : #MbndAstDoWhileLoopNode,
	#superclass : #MbndAstStatementNode,
	#instVars : [
		'condition',
		'action',
		'continueAction'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDoWhileLoopNode >> accept: aVisitor [
	^ aVisitor visitDoWhileLoopNode: self
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> action [
	^ action
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> action: anObject [
	action := anObject
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> condition [
	^ condition
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> continueAction [
	^ continueAction
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> continueAction: anObject [
	continueAction := anObject
]

{ #category : #testing }
MbndAstDoWhileLoopNode >> isDoWhileLoopNode [
	^ true
]
