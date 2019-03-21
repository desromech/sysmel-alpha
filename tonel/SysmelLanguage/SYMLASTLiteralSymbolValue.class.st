Class {
	#name : #SYMLASTLiteralSymbolValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'SysmelLanguage-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralSymbolValue >> literalTypeName [
	^ MbndLiteralSymbolType typeName
]

{ #category : #printing }
SYMLASTLiteralSymbolValue >> printOn: aStream [
	aStream nextPutAll: 'symbol '; print: value
]
