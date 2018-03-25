Class {
	#name : #SYMLASTLanguageScape,
	#superclass : #SYMLASTNode,
	#instVars : [
		'languageName',
		'sourceCode',
		'sourceCodePosition'
	],
	#category : #Sysmel-Parser-AST
}

{ #category : #converting }
SYMLASTLanguageScape >> buildAPSG: builder [
	^ (builder language: languageName source: sourceCode)
		position: self;
		sourceCodePosition: sourceCodePosition;
		withDelimiters: true;
		yourself
]

{ #category : #accessing }
SYMLASTLanguageScape >> languageName [
	^ languageName
]

{ #category : #accessing }
SYMLASTLanguageScape >> languageName: anObject [
	languageName := anObject
]

{ #category : #accessing }
SYMLASTLanguageScape >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
SYMLASTLanguageScape >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #accessing }
SYMLASTLanguageScape >> sourceCodePosition [
	^ sourceCodePosition
]

{ #category : #accessing }
SYMLASTLanguageScape >> sourceCodePosition: anObject [
	sourceCodePosition := anObject asSysmelSourcePosition
]
