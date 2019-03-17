Class {
	#name : #SYMLASTLiteralFloatValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralFloatValue >> literalTypeName [
	^ MbndLiteralFloatType typeName
]

{ #category : #printing }
SYMLASTLiteralFloatValue >> printOn: aStream [
	aStream nextPutAll: 'float '; print: value
]
