Class {
	#name : #MbndLanguageInterface,
	#superclass : #Object,
	#instVars : [
		'targetModule',
		'topLevelLanguageScopeCache'
	],
	#classVars : [
		'MoebiusBandLanguageFileExtensions',
		'MoebiusBandLanguages'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Languages'
}

{ #category : #'class initialization' }
MbndLanguageInterface class >> initialize [
	MoebiusBandLanguages := Dictionary new.
	MoebiusBandLanguageFileExtensions := Dictionary new.
	
	self allSubclassesDo: [ :sc |
		sc languageName ifNotNil: [ :languageName |
			MoebiusBandLanguages at: languageName put: sc
		].
	
		sc languageFileExtensions do: [ :ext |
			MoebiusBandLanguageFileExtensions at: ext put: sc
		]
	].

]

{ #category : #accessing }
MbndLanguageInterface class >> languageFileExtensions [
	^ #()
]

{ #category : #accessing }
MbndLanguageInterface class >> languageForFileExtension: aFileExtension [
	^ MoebiusBandLanguageFileExtensions at: aFileExtension
]

{ #category : #accessing }
MbndLanguageInterface class >> languageName [
	^ nil
]

{ #category : #accessing }
MbndLanguageInterface class >> languageNamed: aLanguageName [
	^ MoebiusBandLanguages at: aLanguageName
]

{ #category : #parsing }
MbndLanguageInterface class >> parseFromFileReference: fileReference forModule: targetModule [
	^ self new parseFromFileReference: fileReference forModule: targetModule
]

{ #category : #parsing }
MbndLanguageInterface class >> parseSourceString: sourceString forModule: targetModule [
	^ self new parseSourceString: sourceString forModule: targetModule
]

{ #category : #scope }
MbndLanguageInterface >> constructTopLevelLanguageScopeFor: aModule [
	self subclassResponsibility
]

{ #category : #initialization }
MbndLanguageInterface >> initialize [
	super initialize.
	topLevelLanguageScopeCache := IdentityDictionary new.
]

{ #category : #parsing }
MbndLanguageInterface >> parse: sourceCollectionWithContext [
	self subclassResponsibility
]

{ #category : #parsing }
MbndLanguageInterface >> parseFromFileReference: fileReference forModule: aTargetModule [
	| source |
	targetModule := aTargetModule.
	source := fileReference contents asMoebiusBandCollectionWithContext.
	source name: fileReference fullName.
	
	^ self parse: source
]

{ #category : #parsing }
MbndLanguageInterface >> parseSourceString: sourceString forModule: aTargetModule [
	targetModule := aTargetModule.
	^ self parse: sourceString asMoebiusBandCollectionWithContext
]

{ #category : #scope }
MbndLanguageInterface >> topLevelLanguageScopeFor: aModule [
	^ topLevelLanguageScopeCache at: aModule ifAbsentPut: [ self constructTopLevelLanguageScopeFor: aModule ]
]
