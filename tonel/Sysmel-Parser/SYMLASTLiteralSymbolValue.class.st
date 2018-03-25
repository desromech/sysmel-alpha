Class {
	#name : #SYMLASTLiteralSymbolValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #Sysmel-Parser-AST
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralSymbolValue >> evaluateInEnvironment: anEnvironment [
	^ value sysmelValueWithType: anEnvironment compilationTarget literalSymbolType inEnvironment: anEnvironment
]

{ #category : #printing }
SYMLASTLiteralSymbolValue >> printOn: aStream [
	aStream nextPutAll: 'symbol '; print: value
]
