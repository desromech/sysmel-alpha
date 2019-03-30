Class {
	#name : #MbndGenericLanguageInterface,
	#superclass : #MbndLanguageInterface,
	#category : #'MoebiusBandMetamodel-Core-Languages'
}

{ #category : #scope }
MbndGenericLanguageInterface >> topLevelLanguageScope [
	^ MbndGenericLanguageTopLevelScope new
]
