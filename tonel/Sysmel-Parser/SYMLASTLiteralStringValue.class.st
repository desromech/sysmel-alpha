Class {
	#name : #SYMLASTLiteralStringValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'Sysmel-Parser-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralStringValue >> literalTypeSelector [
	^ #literalStringType
]

{ #category : #printing }
SYMLASTLiteralStringValue >> printOn: aStream [
	aStream nextPutAll: 'string '; print: value
]
