Class {
	#name : #SYMLASTLiteralArrayValue,
	#superclass : #SYMLASTLiteralValue,
	#instVars : [
		'elements'
	],
	#category : #'Sysmel-Parser-AST'
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
SYMLASTLiteralArrayValue >> literalTypeSelector [
	^ #literalArrayType
]

{ #category : #accessing }
SYMLASTLiteralArrayValue >> value [
	^ value ifNil: [ value := elements collect: #evaluateLiteralArrayElement ]
]
