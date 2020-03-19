Class {
	#name : #MbndAstExceptionCatchExpressionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'exceptionTypeExpression',
		'catchAction',
		'exceptionType',
		'exceptionTypeIsLiteral',
		'caughtExceptionReferenceNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstExceptionCatchExpressionNode >> accept: visitor [
	^ visitor visitExceptionCatchExpressionNode: self
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> catchAction [
	^ catchAction
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> catchAction: anObject [
	catchAction := anObject
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> caughtExceptionReferenceNode [
	^ caughtExceptionReferenceNode
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> caughtExceptionReferenceNode: anObject [
	caughtExceptionReferenceNode := anObject
]

{ #category : #serialization }
MbndAstExceptionCatchExpressionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#exceptionTypeExpression . exceptionTypeExpression encodeGraphForMessagePackWith: graphEncoder.
		#catchAction . catchAction encodeGraphForMessagePackWith: graphEncoder.
		#exceptionType . exceptionType encodeGraphForMessagePackWith: graphEncoder.
		#caughtExceptionReferenceNode . caughtExceptionReferenceNode encodeGraphForMessagePackWith: graphEncoder.
		#exceptionTypeIsLiteral . exceptionTypeIsLiteral.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> exceptionType [
	^ exceptionType
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> exceptionType: anObject [
	exceptionType := anObject
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> exceptionTypeExpression [
	^ exceptionTypeExpression
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> exceptionTypeExpression: anObject [
	exceptionTypeExpression := anObject
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> exceptionTypeIsLiteral [
	^ exceptionTypeIsLiteral
]

{ #category : #accessing }
MbndAstExceptionCatchExpressionNode >> exceptionTypeIsLiteral: anObject [
	exceptionTypeIsLiteral := anObject
]

{ #category : #testing }
MbndAstExceptionCatchExpressionNode >> isExceptionCatchExpressionNode [
	^ true
]

{ #category : #serialization }
MbndAstExceptionCatchExpressionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	exceptionTypeExpression := encodedFields at: #exceptionTypeExpression.
	catchAction := encodedFields at: #catchAction.
	exceptionType := encodedFields at: #exceptionType.
	caughtExceptionReferenceNode := encodedFields at: #caughtExceptionReferenceNode.
	exceptionTypeIsLiteral := encodedFields at: #exceptionTypeIsLiteral.
]
