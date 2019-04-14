Class {
	#name : #SYMLASTLiteralStringValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralStringValue >> literalTypeName [
	^ MbndLiteralStringType typeName
]

{ #category : #printing }
SYMLASTLiteralStringValue >> printOn: aStream [
	aStream nextPutAll: 'string '; print: value
]
