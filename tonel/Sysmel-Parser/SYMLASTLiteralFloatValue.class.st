Class {
	#name : #SYMLASTLiteralFloatValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'Sysmel-Parser-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralFloatValue >> literalTypeSelector [
	^ #literalFloatType
]

{ #category : #printing }
SYMLASTLiteralFloatValue >> printOn: aStream [
	aStream nextPutAll: 'float '; print: value
]
