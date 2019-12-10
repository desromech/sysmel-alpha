Class {
	#name : #MbndAstLiteralValueNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLiteralValueNode >> accept: aVisitor [
	^ aVisitor visitLiteralValueNode: self
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> asLiteralValuePatternNode [
	^ MbndAstPatternMatchingLiteralValuePatternNode new
		position: self;
		value: value;
		type: type;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> evaluateMbndValue [
	^ value asMoebiusValueWithType: type
]

{ #category : #testing }
MbndAstLiteralValueNode >> isLiteralSymbolValueNode [
	^ type isLiteralSymbolType
]

{ #category : #testing }
MbndAstLiteralValueNode >> isLiteralValueNode [
	^ true
]

{ #category : #printing }
MbndAstLiteralValueNode >> printValueString [
	^ value printString
]

{ #category : #accessing }
MbndAstLiteralValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstLiteralValueNode >> value: anObject [
	value := anObject
]
