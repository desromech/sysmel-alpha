Class {
	#name : #SYMLASTLiteralIntegerValue,
	#superclass : #SYMLASTLiteralValue,
	#category : #Sysmel-Parser-AST
}

{ #category : #'as yet unclassified' }
SYMLASTLiteralIntegerValue >> evaluateInEnvironment: anEnvironment [
	^ value sysmelValueWithType: anEnvironment compilationTarget literalIntegerType inEnvironment: anEnvironment
]

{ #category : #printing }
SYMLASTLiteralIntegerValue >> printOn: aStream [
	aStream nextPutAll: 'integer '; print: value
]
