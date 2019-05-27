Class {
	#name : #MbndAstSetFieldValueNode,
	#superclass : #MbndAstAbstractFieldAccessNode,
	#instVars : [
		'newValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSetFieldValueNode >> accept: aVisitor [
	^ aVisitor visitSetFieldValueNode: self
]

{ #category : #testing }
MbndAstSetFieldValueNode >> isSetFieldValueNode [
	^ true
]

{ #category : #accessing }
MbndAstSetFieldValueNode >> newValue [
	^ newValue
]

{ #category : #accessing }
MbndAstSetFieldValueNode >> newValue: anObject [
	newValue := anObject
]
