Class {
	#name : #SYMLASTLiteralStringValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'SysmelLanguage-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralStringValue >> literalTypeName [
	^ MbndLiteralStringType typeName
]

{ #category : #printing }
SYMLASTLiteralStringValue >> printOn: aStream [
	aStream nextPutAll: 'string '; print: value
]
