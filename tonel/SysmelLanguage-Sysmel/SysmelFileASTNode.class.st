Class {
	#name : #SysmelFileASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'expressionList'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelFileASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitFile: self
]

{ #category : #generated }
SysmelFileASTNode >> expressionList [
	^ expressionList
]

{ #category : #generated }
SysmelFileASTNode >> expressionList: aSysmelExpressionListASTNode [
	self expressionList notNil
		ifTrue: [ self expressionList parent: nil ].
	expressionList := aSysmelExpressionListASTNode.
	self expressionList notNil
		ifTrue: [ self expressionList parent: self ]
]

{ #category : #generated }
SysmelFileASTNode >> nodeVariables [
	^ #(#expressionList)
]
