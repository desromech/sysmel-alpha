Class {
	#name : #MbndGenericLanguageInterface,
	#superclass : #MbndLanguageInterface,
	#category : #'MoebiusBandMetamodel-Core-Languages'
}

{ #category : #scope }
MbndGenericLanguageInterface >> topLevelLanguageScopeFor: aModule [
	^ MbndGenericLanguageTopLevelScope for: aModule
]
