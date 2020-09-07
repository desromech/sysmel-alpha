Class {
	#name : #MbndPharoEmbeddedDoItLanguage,
	#superclass : #MbndPharoDoItLanguage,
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #accessing }
MbndPharoEmbeddedDoItLanguage class >> languageName [
	^ #pharoEmbedded
]

{ #category : #'as yet unclassified' }
MbndPharoEmbeddedDoItLanguage >> strictPharoMode [
	^ false
]
