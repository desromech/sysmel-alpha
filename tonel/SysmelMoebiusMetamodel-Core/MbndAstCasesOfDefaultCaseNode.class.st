Class {
	#name : #MbndAstCasesOfDefaultCaseNode,
	#superclass : #MbndAstCasesOfAbstractCaseNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfDefaultCaseNode >> accept: aVisitor [
	^ aVisitor visitCasesOfDefaultCaseNode: self
]

{ #category : #testing }
MbndAstCasesOfDefaultCaseNode >> isCasesOfDefaultCaseNode [
	^ true
]
