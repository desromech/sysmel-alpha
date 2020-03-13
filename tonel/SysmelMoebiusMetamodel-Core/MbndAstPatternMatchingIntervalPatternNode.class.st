Class {
	#name : #MbndAstPatternMatchingIntervalPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'start',
		'stop'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingIntervalPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingIntervalPatternNode: self
]

{ #category : #testing }
MbndAstPatternMatchingIntervalPatternNode >> isPatternMatchingIntervalPatternNode [
	^ true
]

{ #category : #testing }
MbndAstPatternMatchingIntervalPatternNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ true
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> start [
	^ start
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> start: anObject [
	start := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> stop [
	^ stop
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> stop: anObject [
	stop := anObject
]
