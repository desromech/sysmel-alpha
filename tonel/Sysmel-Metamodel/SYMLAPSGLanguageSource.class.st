Class {
	#name : #SYMLAPSGLanguageSource,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'language',
		'sourceCode',
		'sourceCodePosition',
		'withDelimiters'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #converting }
SYMLAPSGLanguageSource >> evaluateInEnvironment: anEnvironment [
	^ (SYMLScapedLanguageCompiler compilerForLanguage: language) evaluateNode: self inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> language [
	^ language
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> language: anObject [
	language := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGLanguageSource >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGLanguageSource >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> sourceCodePosition [
	^ sourceCodePosition
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> sourceCodePosition: anObject [
	sourceCodePosition := anObject asSysmelSourcePosition
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> withDelimiters [
	^ withDelimiters
]

{ #category : #accessing }
SYMLAPSGLanguageSource >> withDelimiters: anObject [
	withDelimiters := anObject
]
