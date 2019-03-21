Class {
	#name : #SYMLASTLiteralCharacterValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'SysmelLanguage-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralCharacterValue >> literalTypeName [
	^ MbndLiteralCharacterType typeName
]

{ #category : #printing }
SYMLASTLiteralCharacterValue >> printOn: aStream [
	aStream nextPutAll: 'character '; print: value
]
