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

{ #category : #serialization }
MbndAstIfConditionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#condition . condition encodeGraphForMessagePackWith: graphEncoder.
		#trueValue . trueValue encodeGraphForMessagePackWith: graphEncoder.
		#falseValue . falseValue encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
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

{ #category : #serialization }
MbndAstIfConditionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	condition := encodedFields at: #condition.
	trueValue := encodedFields at: #trueValue.
	falseValue := encodedFields at: #falseValue.
]

{ #category : #accessing }
MbndAstIfConditionNode >> trueValue [
	^ trueValue
]

{ #category : #accessing }
MbndAstIfConditionNode >> trueValue: anObject [
	trueValue := anObject
]
