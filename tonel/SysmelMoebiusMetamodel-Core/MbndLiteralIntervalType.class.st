Class {
	#name : #MbndLiteralIntervalType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralIntervalType class >> typeName [
	^ #_LiteralInterval
]

{ #category : #initialization }
MbndLiteralIntervalType >> analyzeValueAsPatternMatchingPattern: node with: analyzer [
	self assert: node isLiteralValueNode.
	^ analyzer visitNode: (MbndAstPatternMatchingIntervalPatternNode new
		start: node value first;
		stop: node value second;
		yourself)
]

{ #category : #testing }
MbndLiteralIntervalType >> isLiteralIntervalType [
	^ true
]
