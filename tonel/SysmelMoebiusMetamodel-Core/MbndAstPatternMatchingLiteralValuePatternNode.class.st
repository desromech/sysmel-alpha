Class {
	#name : #MbndAstPatternMatchingLiteralValuePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingLiteralValuePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingLiteralValuePatternNode: self
]

{ #category : #testing }
MbndAstPatternMatchingLiteralValuePatternNode >> isPatternMatchingLiteralValuePatternNode [
	^ true
]

{ #category : #testing }
MbndAstPatternMatchingLiteralValuePatternNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ true
]

{ #category : #accessing }
MbndAstPatternMatchingLiteralValuePatternNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstPatternMatchingLiteralValuePatternNode >> value: anObject [
	value := anObject
]
