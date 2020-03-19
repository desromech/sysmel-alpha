Class {
	#name : #MbndGenericLanguageInterface,
	#superclass : #MbndLanguageInterface,
	#category : #'SysmelMoebiusMetamodel-Core-Languages'
}

{ #category : #scope }
MbndGenericLanguageInterface >> constructTopLevelLanguageScopeFor: aModule [
	^ (MbndGenericLanguageTopLevelScope for: aModule)
		languageName: self languageName;
		yourself
]
