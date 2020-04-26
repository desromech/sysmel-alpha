Class {
	#name : #MbndAstPatternMatchingAnyPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingAnyPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingAnyPatternNode: self
]

{ #category : #testing }
MbndAstPatternMatchingAnyPatternNode >> isDefaultPattern [
	^ true
]
