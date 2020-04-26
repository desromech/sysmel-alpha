Class {
	#name : #MbndAstPatternMatchingTuplePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'expectedElements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingTuplePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingTuplePatternNode: self
]

{ #category : #accessing }
MbndAstPatternMatchingTuplePatternNode >> expectedElements [
	^ expectedElements
]

{ #category : #accessing }
MbndAstPatternMatchingTuplePatternNode >> expectedElements: anObject [
	expectedElements := anObject
]
