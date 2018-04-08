Class {
	#name : #SYMLASTLiteralCharacterValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #'Sysmel-Parser-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralCharacterValue >> literalTypeSelector [
	^ #literalCharacterType
]

{ #category : #printing }
SYMLASTLiteralCharacterValue >> printOn: aStream [
	aStream nextPutAll: 'character '; print: value
]
