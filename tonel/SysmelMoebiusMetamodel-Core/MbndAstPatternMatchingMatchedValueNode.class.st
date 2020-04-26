Class {
	#name : #MbndAstPatternMatchingMatchedValueNode,
	#superclass : #MbndAstNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingMatchedValueNode >> accept: visitor [
	^ visitor visitMatchingMatchedValueNode: self
]

{ #category : #testing }
MbndAstPatternMatchingMatchedValueNode >> isMatchingMatchedValueNode [
	^ true
]
