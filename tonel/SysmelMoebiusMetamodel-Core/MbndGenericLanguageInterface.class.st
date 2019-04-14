Class {
	#name : #MbndGenericLanguageInterface,
	#superclass : #MbndLanguageInterface,
	#category : #'SysmelMoebiusMetamodel-Core-Languages'
}

{ #category : #scope }
MbndGenericLanguageInterface >> topLevelLanguageScopeFor: aModule [
	^ MbndGenericLanguageTopLevelScope for: aModule
]
