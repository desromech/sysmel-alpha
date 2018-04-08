Class {
	#name : #SYMLASTLiteralSymbolValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'Sysmel-Parser-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralSymbolValue >> literalTypeSelector [
	^ #literalSymbolType
]

{ #category : #printing }
SYMLASTLiteralSymbolValue >> printOn: aStream [
	aStream nextPutAll: 'symbol '; print: value
]
