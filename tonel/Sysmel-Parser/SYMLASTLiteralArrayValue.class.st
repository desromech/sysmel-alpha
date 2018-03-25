Class {
	#name : #SYMLASTLiteralArrayValue,
	#superclass : #SYMLASTLiteralValue,
	#instVars : [
		'elements'
	],
	#category : #Sysmel-Parser-AST
}

{ #category : #accessing }
SYMLASTLiteralArrayValue >> elements [
	^ elements
]

{ #category : #accessing }
SYMLASTLiteralArrayValue >> elements: anObject [
	elements := anObject
]

{ #category : #'as yet unclassified' }
SYMLASTLiteralArrayValue >> evaluateInEnvironment: anEnvironment [
	^ self value sysmelValueWithType: anEnvironment compilationTarget literalArrayType inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLASTLiteralArrayValue >> value [
	^ value ifNil: [ value := elements collect: #evaluateLiteralArrayElement ]
]
