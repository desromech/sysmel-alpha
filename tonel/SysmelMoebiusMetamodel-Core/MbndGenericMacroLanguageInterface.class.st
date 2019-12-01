"
I am a generic language that is used for testing the AST nodes. I do not parse sources.
"
Class {
	#name : #MbndGenericMacroLanguageInterface,
	#superclass : #MbndGenericLanguageInterface,
	#category : #'SysmelMoebiusMetamodel-Core-Languages'
}

{ #category : #scope }
MbndGenericMacroLanguageInterface >> constructTopLevelLanguageScopeFor: aModule [
	^ MbndGenericMacroLanguageTopLevelScope for: aModule
]
