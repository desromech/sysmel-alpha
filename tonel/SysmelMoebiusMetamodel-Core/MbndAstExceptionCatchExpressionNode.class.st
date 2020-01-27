Class {
	#name : #MbndAstExceptionCatchExpressionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'exceptionTypeExpression',
		'catchAction',
		'exceptionType',
		'exceptionTypeIsLiteral'
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
