Class {
	#name : #SYMLASTLiteralIntegerValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'Sysmel-Parser-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralIntegerValue >> literalTypeSelector [
	^ #literalIntegerType
]

{ #category : #printing }
SYMLASTLiteralIntegerValue >> printOn: aStream [
	aStream nextPutAll: 'integer '; print: value
]
