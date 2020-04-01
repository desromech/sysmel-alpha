Class {
	#name : #MbndAstPatternMatchingSetValuePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingSetValuePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingSetPatternNode: self
]

{ #category : #accessing }
MbndAstPatternMatchingSetValuePatternNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstPatternMatchingSetValuePatternNode >> elements: anObject [
	elements := anObject
]

{ #category : #testing }
MbndAstPatternMatchingSetValuePatternNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ true
]

{ #category : #testing }
MbndAstPatternMatchingSetValuePatternNode >> isPatternMatchingSetValuePatternNode [
	^ true
]
