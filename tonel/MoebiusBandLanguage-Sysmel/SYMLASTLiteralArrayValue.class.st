Class {
	#name : #SYMLASTLiteralArrayValue,
	#superclass : #SYMLASTLiteralValue,
	#instVars : [
		'elements'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
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
SYMLASTLiteralArrayValue >> literalTypeName [
	^ MbndLiteralArrayType typeName
]

{ #category : #accessing }
SYMLASTLiteralArrayValue >> value [
	^ value ifNil: [ value := elements collect: #evaluateLiteralArrayElement ]
]
