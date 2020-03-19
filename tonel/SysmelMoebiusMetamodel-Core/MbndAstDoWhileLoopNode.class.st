Class {
	#name : #MbndAstDoWhileLoopNode,
	#superclass : #MbndAstStatementNode,
	#instVars : [
		'condition',
		'action',
		'continueAction'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDoWhileLoopNode >> accept: aVisitor [
	^ aVisitor visitDoWhileLoopNode: self
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> action [
	^ action
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> action: anObject [
	action := anObject
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> condition [
	^ condition
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> continueAction [
	^ continueAction
]

{ #category : #accessing }
MbndAstDoWhileLoopNode >> continueAction: anObject [
	continueAction := anObject
]

{ #category : #serialization }
MbndAstDoWhileLoopNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#condition . condition encodeGraphForMessagePackWith: graphEncoder.
		#action . action encodeGraphForMessagePackWith: graphEncoder.
		#continueAction . continueAction encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstDoWhileLoopNode >> isDoWhileLoopNode [
	^ true
]

{ #category : #serialization }
MbndAstDoWhileLoopNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	condition := encodedFields at: #condition.
	action := encodedFields at: #action.
	continueAction := encodedFields at: #continueAction.
]
