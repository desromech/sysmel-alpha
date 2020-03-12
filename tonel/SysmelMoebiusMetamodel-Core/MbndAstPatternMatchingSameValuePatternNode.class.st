Class {
	#name : #MbndAstPatternMatchingSameValuePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'expectedValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingSameValuePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingSameValuePatternNode: self
]

{ #category : #converting }
MbndAstPatternMatchingSameValuePatternNode >> asSameValuePatternNode [
	^ self
]

{ #category : #accessing }
MbndAstPatternMatchingSameValuePatternNode >> expectedValue [
	^ expectedValue
]

{ #category : #accessing }
MbndAstPatternMatchingSameValuePatternNode >> expectedValue: anObject [
	expectedValue := anObject
]

{ #category : #testing }
MbndAstPatternMatchingSameValuePatternNode >> isPatternMatchingSameValuePatternNode [
	^ true
]
