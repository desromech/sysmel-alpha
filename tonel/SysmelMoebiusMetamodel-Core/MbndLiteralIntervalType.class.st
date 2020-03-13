Class {
	#name : #MbndLiteralIntervalType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralIntervalType class >> typeName [
	^ #_LiteralInterval
]

{ #category : #testing }
MbndLiteralIntervalType >> isLiteralIntervalType [
	^ true
]
