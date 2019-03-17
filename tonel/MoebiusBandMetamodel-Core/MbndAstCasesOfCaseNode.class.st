Class {
	#name : #MbndAstCasesOfCaseNode,
	#superclass : #MbndAstCasesOfAbstractCaseNode,
	#instVars : [
		'pattern'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfCaseNode >> accept: aVisitor [
	^ aVisitor visitCasesOfCaseNode: self
]

{ #category : #testing }
MbndAstCasesOfCaseNode >> isCasesOfCaseNode [
	^ true
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> pattern [
	^ pattern
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> pattern: anObject [
	pattern := anObject
]
