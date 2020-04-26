Class {
	#name : #MbndAstPatternMatchingNeverPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingNeverPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingNeverPatternNode: self
]

{ #category : #testing }
MbndAstPatternMatchingNeverPatternNode >> isNeverPattern [
	^ true
]
