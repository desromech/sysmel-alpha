Class {
	#name : #MbndPharoMethodEmbeddedLanguage,
	#superclass : #MbndPharoMethodLanguage,
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #accessing }
MbndPharoMethodEmbeddedLanguage class >> languageName [
	^ #pharoMethodEmbedded
]

{ #category : #'as yet unclassified' }
MbndPharoMethodEmbeddedLanguage >> strictPharoMode [
	^ false
]
