Class {
	#name : #SYMLASTLiteralIntegerValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralIntegerValue >> literalTypeName [
	^ MbndLiteralIntegerType typeName
]

{ #category : #printing }
SYMLASTLiteralIntegerValue >> printOn: aStream [
	aStream nextPutAll: 'integer '; print: value
]
