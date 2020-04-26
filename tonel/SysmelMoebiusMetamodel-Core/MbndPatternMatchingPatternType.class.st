Class {
	#name : #MbndPatternMatchingPatternType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPatternMatchingPatternType class >> typeName [
	^ #_PatternMatchingPattern
]

{ #category : #initialization }
MbndPatternMatchingPatternType >> analyzeValueAsPatternMatchingPattern: node with: analyzer [
	^ node
]

{ #category : #testing }
MbndPatternMatchingPatternType >> isPatternMatchingPatternType [
	^ true
]
