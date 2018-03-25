Class {
	#name : #SYMLASTLiteralCharacterValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #Sysmel-Parser-AST
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralCharacterValue >> evaluateInEnvironment: anEnvironment [
	^ value sysmelValueWithType: anEnvironment compilationTarget literalCharacterType inEnvironment: anEnvironment
]

{ #category : #printing }
SYMLASTLiteralCharacterValue >> printOn: aStream [
	aStream nextPutAll: 'character '; print: value
]
