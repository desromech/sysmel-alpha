Class {
	#name : #SYMLASTLiteralFloatValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'SysmelLanguage-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralFloatValue >> literalTypeName [
	^ MbndLiteralFloatType typeName
]

{ #category : #printing }
SYMLASTLiteralFloatValue >> printOn: aStream [
	aStream nextPutAll: 'float '; print: value
]
