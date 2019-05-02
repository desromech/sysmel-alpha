Class {
	#name : #MbndAstCastNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'targetType',
		'typeConversionRule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstCastNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstCastNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstCastNode >> isCastNode [
	^ true
]

{ #category : #accessing }
MbndAstCastNode >> targetType [
	^ targetType
]

{ #category : #accessing }
MbndAstCastNode >> targetType: anObject [
	targetType := anObject
]

{ #category : #accessing }
MbndAstCastNode >> typeConversionRule [
	^ typeConversionRule
]

{ #category : #accessing }
MbndAstCastNode >> typeConversionRule: anObject [
	typeConversionRule := anObject
]
