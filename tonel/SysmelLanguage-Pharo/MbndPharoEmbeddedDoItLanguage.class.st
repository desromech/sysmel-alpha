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
	^ MbndGenericLanguageTopLevelScope for: aModule
]
