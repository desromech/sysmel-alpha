Class {
	#name : #MbndAstIfConditionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'condition',
		'trueValue',
		'falseValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIfConditionNode >> accept: aVisitor [
	^ aVisitor visitIfConditionNode: self
]

{ #category : #accessing }
MbndAstIfConditionNode >> condition [
	^ condition
]

{ #category : #accessing }
MbndAstIfConditionNode >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
MbndAstIfConditionNode >> falseValue [
	^ falseValue
]

{ #category : #accessing }
MbndAstIfConditionNode >> falseValue: anObject [
	falseValue := anObject
]

{ #category : #testing }
MbndAstIfConditionNode >> isIfConditionNode [
	^ true
]

{ #category : #accessing }
MbndAstIfConditionNode >> trueValue [
	^ trueValue
]

{ #category : #accessing }
MbndAstIfConditionNode >> trueValue: anObject [
	trueValue := anObject
]
