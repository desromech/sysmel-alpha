Class {
	#name : #SYMLASTLiteralValue,
	#superclass : #SYMLASTNode,
	#instVars : [
		'value'
	],
	#category : #Sysmel-Parser-AST
}

{ #category : #converting }
SYMLASTLiteralValue >> buildAPSG: builder [
	^ (builder literal: (self evaluateInEnvironment: builder environment))
		position: self
]

{ #category : #'as yet unclassified' }
SYMLASTLiteralValue >> evaluateLiteralArrayElement [
	^ self value
]

{ #category : #accessing }
SYMLASTLiteralValue >> value [
	^ value
]

{ #category : #accessing }
SYMLASTLiteralValue >> value: anObject [
	value := anObject
]
