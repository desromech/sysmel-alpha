Class {
	#name : #SYMLASTLiteralStringValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #Sysmel-Parser-AST
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralStringValue >> evaluateInEnvironment: anEnvironment [
	^ value sysmelValueWithType: anEnvironment compilationTarget literalStringType inEnvironment: anEnvironment
]

{ #category : #printing }
SYMLASTLiteralStringValue >> printOn: aStream [
	aStream nextPutAll: 'string '; print: value
]
