Class {
	#name : #MbndAstTupleSplicingNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'tupleExpression',
		'elementIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstTupleSplicingNode >> accept: visitor [
	^ visitor visitTupleSplicingNode: self
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> elementIndex [
	^ elementIndex
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> elementIndex: anObject [
	elementIndex := anObject
]

{ #category : #testing }
MbndAstTupleSplicingNode >> isTupleSplicingNode [
	^ true
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> tupleExpression [
	^ tupleExpression
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> tupleExpression: anObject [
	tupleExpression := anObject
]
