Class {
	#name : #MbndPharoEmbeddedDoItLanguage,
	#superclass : #MbndPharoDoItLanguage,
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #accessing }
MbndPharoEmbeddedDoItLanguage class >> languageName [
	^ #pharoEmbedded
]

{ #category : #scope }
MbndPharoEmbeddedDoItLanguage >> constructTopLevelLanguageScopeFor: aModule [
	^ (MbndGenericMacroLanguageTopLevelScope for: aModule)
		languageName: self languageName;
		yourself
]

{ #category : #'as yet unclassified' }
MbndPharoEmbeddedDoItLanguage >> strictPharoMode [
	^ false
]
