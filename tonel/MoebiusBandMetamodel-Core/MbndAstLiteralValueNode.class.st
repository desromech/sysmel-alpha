Class {
	#name : #MbndAstLiteralValueNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'value',
		'type'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLiteralValueNode >> accept: aVisitor [
	^ aVisitor visitLiteralValueNode: self
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> evaluateMbndValue [
	^ MbndValue new
		value: value;
		type: type;
		yourself
]

{ #category : #testing }
MbndAstLiteralValueNode >> isLiteralValueNode [
	^ true
]

{ #category : #accessing }
MbndAstLiteralValueNode >> type [
	^ type
]

{ #category : #accessing }
MbndAstLiteralValueNode >> type: anObject [
	type := anObject
]

{ #category : #accessing }
MbndAstLiteralValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstLiteralValueNode >> value: anObject [
	value := anObject
]
