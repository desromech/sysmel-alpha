Class {
	#name : #SYMLASTLiteralIntegerValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralIntegerValue >> literalTypeName [
	^ MbndLiteralIntegerType typeName
]

{ #category : #printing }
SYMLASTLiteralIntegerValue >> printOn: aStream [
	aStream nextPutAll: 'integer '; print: value
]
