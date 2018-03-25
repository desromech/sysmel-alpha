Class {
	#name : #SYMLASTLiteralFloatValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #Sysmel-Parser-AST
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralFloatValue >> evaluateInEnvironment: anEnvironment [
	^ value sysmelValueWithType: anEnvironment compilationTarget literalFloatType inEnvironment: anEnvironment
]

{ #category : #printing }
SYMLASTLiteralFloatValue >> printOn: aStream [
	aStream nextPutAll: 'float '; print: value
]
