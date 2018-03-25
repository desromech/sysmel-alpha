Class {
	#name : #SYMLScapedLanguageCompiler,
	#superclass : #Object,
	#classVars : [
		'CompilersForLanguages'
	],
	#category : #Sysmel-Metamodel-APSG
}

{ #category : #'as yet unclassified' }
SYMLScapedLanguageCompiler class >> compilerForLanguage: languageName [
	^ CompilersForLanguages at: languageName
]

{ #category : #initialization }
SYMLScapedLanguageCompiler class >> initialize [
	CompilersForLanguages := Dictionary new.
	self allSubclassesDo: [ :sc |
		CompilersForLanguages at: sc languageName put: sc new
	]
]

{ #category : #accessing }
SYMLScapedLanguageCompiler class >> languageName [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLScapedLanguageCompiler class >> tryToStyle: token language: language into: commands [
	CompilersForLanguages at: language ifPresent: [ :compiler | compiler tryToStyle: token into: commands ]
]

{ #category : #compiling }
SYMLScapedLanguageCompiler >> evaluateNode: aNode inEnvironment: anEnvironment [
	self subclassResponsibility
]

{ #category : #styling }
SYMLScapedLanguageCompiler >> style: token into: commands [
]

{ #category : #accessing }
SYMLScapedLanguageCompiler >> tryToStyle: token into: commands [
	[
		self style: token into: commands
	] on: Error do: [ :err | ]
]
