Class {
	#name : #MbndLanguageParsedSource,
	#superclass : #Object,
	#instVars : [
		'language',
		'ast'
	],
	#category : #'MoebiusBandMetamodel-Core-Languages'
}

{ #category : #accessing }
MbndLanguageParsedSource >> ast [
	^ ast
]

{ #category : #accessing }
MbndLanguageParsedSource >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
MbndLanguageParsedSource >> language [
	^ language
]

{ #category : #accessing }
MbndLanguageParsedSource >> language: anObject [
	language := anObject
]
