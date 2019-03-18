Trait {
	#name : #TMbndModule,
	#instVars : [
		'globalNamespace'
	],
	#category : #'MoebiusBandMetamodel-Core-Module'
}

{ #category : #accessing }
TMbndModule >> compilationTarget [
	self explicitRequirement
]

{ #category : #parsing }
TMbndModule >> evaluateAST: ast [
	self halt
]

{ #category : #parsing }
TMbndModule >> evaluateLanguage: languageName source: sourceString [
	| ast |
	ast := self parseLanguage: languageName source: sourceString.
	^ self evaluateAST: ast
]

{ #category : #parsing }
TMbndModule >> parseFileNamed: fileName [
	| language fileReference |
	fileReference := fileName asFileReference.
	language := MbndLanguageInterface languageForFileExtension: fileReference extension.
	^ language parseFromFileReference: fileReference forModule: self
]

{ #category : #parsing }
TMbndModule >> parseLanguage: languageName source: sourceString [
	| language |
	language := MbndLanguageInterface languageNamed: languageName.
	^ language parseSourceString: sourceString forModule: self
]
