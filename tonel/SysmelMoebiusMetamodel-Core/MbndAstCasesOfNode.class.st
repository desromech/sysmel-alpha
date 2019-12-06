Class {
	#name : #MbndAstCasesOfNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matchedExpression',
		'cases',
		'hasDefaultCase'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
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

{ #category : #accessing }
MbndAstCasesOfNode >> hasDefaultCase [
	^ hasDefaultCase ifNil: [ hasDefaultCase := false ]
]

{ #category : #accessing }
MbndAstCasesOfNode >> hasDefaultCase: anObject [
	hasDefaultCase := anObject
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
