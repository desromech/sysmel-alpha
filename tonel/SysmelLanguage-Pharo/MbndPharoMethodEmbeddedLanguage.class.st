Class {
	#name : #MbndPharoMethodEmbeddedLanguage,
	#superclass : #MbndPharoMethodLanguage,
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #accessing }
MbndPharoMethodEmbeddedLanguage class >> languageName [
	^ #pharoMethodEmbedded
]

{ #category : #scope }
MbndPharoMethodEmbeddedLanguage >> constructTopLevelLanguageScopeFor: aModule [
	^ (MbndGenericMacroLanguageTopLevelScope for: aModule)
		languageName: self languageName;
		yourself
]

{ #category : #'as yet unclassified' }
MbndPharoMethodEmbeddedLanguage >> strictPharoMode [
	^ false
]
