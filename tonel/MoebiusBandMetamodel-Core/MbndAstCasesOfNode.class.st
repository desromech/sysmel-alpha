Class {
	#name : #MbndAstCasesOfNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matchedExpression',
		'cases'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfNode >> accept: aVisitor [
	^ aVisitor visitCasesOfNode: self
]

{ #category : #accessing }
MbndAstCasesOfNode >> cases [
	^ cases
]

{ #category : #accessing }
MbndAstCasesOfNode >> cases: anObject [
	cases := anObject
]

{ #category : #testing }
MbndAstCasesOfNode >> isCasesOfNode [
	^ true
]

{ #category : #accessing }
MbndAstCasesOfNode >> matchedExpression [
	^ matchedExpression
]

{ #category : #accessing }
MbndAstCasesOfNode >> matchedExpression: anObject [
	matchedExpression := anObject
]
